//
//  HomeViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/14/25.
//

import SwiftUI
import Combine
import MapKit


class HomeViewModel: NSObject, ObservableObject {
    
    
    let tripService: TripService
    let userService:  UserService
    
    
    @Published var drivers: [AppUser] = []
    @Published var trip : Trip?
   
    private var cancellables = Set<AnyCancellable>()
    private var currentUser: AppUser?
    
    // MARK: - Location Search Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: Date?
    @Published var dropoffTime: Date?
    var userLocation: CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    init (userService: UserService, tripService: TripService) {
        self.userService = userService
        self.tripService = tripService
        super.init()
        fetchAppUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
   
    
    func fetchAppUser() {
        userService.userPublisher.sink { user in
            self.currentUser = user
            self.fetchDrivers()
            self.addTripObserverForDriver()
            self.addTripObserverForRider()
        }
        .store(in: &cancellables)
    }
    
    func cancelTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .cancelled)
        tripService.updateTrip(id: trip.id, update: updateTrip) { _ in
            
        }
    }
    
}


// MARK: - Rider API

extension HomeViewModel {
    
    
    func addTripObserverForRider() {
        guard let currentUser = currentUser, currentUser.accountType == .rider else { return }
        tripService.addTripObserver(forRider: currentUser.uid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure (let error) = completion {
                    debugPrint("Error in observe rider trip: \(error)")
                }
            } receiveValue: { trip in
                self.trip = trip
            }
            .store(in: &cancellables)

    }
    
    func requestTrip(rideType: RideType) {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedUberLocation else { return }
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        getUberLocationFromCLLocation(userLocation) { riderLocation in
            guard let riderLocation = riderLocation else { return }
            
            let tripCost = self.computeRidePrice(forType: rideType)
            let trip = Trip(
                id: NSUUID().uuidString,
                riderUid: currentUser.uid,
                driverUid: driver.uid,
                riderName: currentUser.firstname,
                driverName: currentUser.firstname,
                pickupLocation: riderLocation,
                dropoffLocation: dropoffLocation,
                tripCost: tripCost,
                rideType: rideType,
                state: .requested
            )
            
            self.tripService.createTrip(trip: trip) { result in
                
            }
        }
    }
    
    func fetchDrivers() {
        guard self.currentUser?.accountType == .rider else { return }
        userService.fetchDrivers { drivers in
            if let drivers = drivers {
                self.drivers = drivers
            }
        }
    }
}


// MARK: - DriverAPI

extension HomeViewModel {
    
    func addTripObserverForDriver() {
        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }
        tripService.addTripObserver(forDriver: currentUser.uid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure (let error) = completion {
                    debugPrint("Error in observe driver trip: \(error)")
                }
            } receiveValue: { trip in
                self.trip = trip
                self.getDestinationRoute(from: currentUser.coordinates.toCLLocationCoordinate2D(), to: trip.pickupLocation.toCLLocationCoordinate2D()) { route in
                    self.trip?.travelTimeToPickup = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPickup = route.distance
                }
                
                self.getDestinationRoute(from: trip.pickupLocation.toCLLocationCoordinate2D(), to: trip.dropoffLocation.toCLLocationCoordinate2D()) { route in
                    self.trip?.travelTimeToDropoff = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToDropoff = route.distance
                }
            }
            .store(in: &cancellables)

    }
    
//    func fetchTrips() {
//        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }
//       SupabaseTripService.shared.fetchTrips(forDriver: currentUser.uid) { trips in
//           if let trip = trips.first {
//               self.trip = trip
//               
//               
//           }
//        }
//    }
    
    
    func rejectTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .rejected)
        tripService.updateTrip(id: trip.id, update: updateTrip) { success in
            if success {
                self.trip = nil
            }
        }
    }
    
    
    func acceptTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .accepted,
                                    travelDetails: trip.travelDetails
        )
        tripService.updateTrip(id: trip.id, update: updateTrip) { success in
            if success {
                
            }
        }
    }
}


// MARK: - LocationSearchHelpers

extension HomeViewModel {
    
    
    func getUberLocationFromCLLocation(_ location: CLLocation, completion: @escaping (UberLocation?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                debugPrint("Error reversing location \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                debugPrint("No placemark found for location")
                completion(nil)
                return
            }
            
            guard placemark.name != nil else {
                debugPrint("No name found for placemark")
                completion(nil)
                return
            }
            
            let uberLocation = UberLocation(
                title: placemark.name!, address: placemark.formattedAddress, coordinate: UserCoordinates.from(coordinate: location.coordinate)
            )
            
            completion(uberLocation)
        }
    }
    
  
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Error searching for location: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            let uberLocation = UberLocation(title: localSearch.title, address: localSearch.subtitle, coordinate: UserCoordinates.from(coordinate: coordinate))
            
            switch config {
            case .ride:
                self.selectedUberLocation = uberLocation
            case .savedLocation(let viewModel):
                guard let uid = SupabaseManager.auth.currentUser?.id.uuidString else { return }
                let savedLocation = SavedLocation.fromUberLocation(uberLocation)
                
                
                let updateUser: UpdateUser
                
                if viewModel == .home {
                     updateUser = UpdateUser(home: savedLocation)
                } else {
                     updateUser = UpdateUser(work: savedLocation)
                }
                                            
                Task {
                    try?  await SupabaseManager.table("users")
                        .update(updateUser)
                        .eq("uid", value: uid)
                        .execute()
                    
                }
            }
            
            
            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userLocationCoordinate = self.userLocation else {return 0.0}
        
        let userLocation = CLLocation(latitude: userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
        
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = destination.distance(from: userLocation)
        return type.computePrice(for: tripDistanceInMeters)
        
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                return
            }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            
            completion(route)
        }
    }
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        pickupTime = Date()
        dropoffTime = Date() + expectedTravelTime
    }
    
}


// MARK: - MKLocalSearchCompleteterDelegate
extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
