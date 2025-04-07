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
    
    @Published var riderRequest: TripRequest?
    @Published var driverRequests: [TripRequest] = []
    
   
    private var cancellables = Set<AnyCancellable>()
    private var currentUser: AppUser?
    
    // MARK: - Location Search Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    
    @Published var selectedPickupLocation: UberLocation? {
        didSet {
            pickupQueryFragment = selectedPickupLocation?.title ?? ""
        }
    }
    @Published var selectedDropoffLocation: UberLocation? {
        didSet {
            droppoffQueryFragment = selectedDropoffLocation?.title ?? ""
        }
    }
    
    
    @Published var pickupTime: Date?
    @Published var dropoffTime: Date?
    var userLocation: CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    
    var pickupQueryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = pickupQueryFragment
            if (pickupQueryFragment.isEmpty) {
                results.removeAll()
            }
        }
    }
    
    var droppoffQueryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = droppoffQueryFragment
            if (droppoffQueryFragment.isEmpty) {
                results.removeAll()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init (userService: UserService, tripService: TripService) {
        self.userService = userService
        self.tripService = tripService
        super.init()
        fetchAppUser()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]
        searchCompleter.queryFragment = droppoffQueryFragment
    }
    
    
    func fetchAppUser() {
        userService.userPublisher.sink { user in
            self.currentUser = user
            self.fetchDrivers()
            self.addTripObserverForUser()
            self.addRiderRequestObserver()
            self.addDriverRequestsObserver()
        }
        .store(in: &cancellables)
    }
    
    func cancelTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .cancelled)
        tripService.updateTrip(id: trip.id, update: updateTrip) { _ in
            
        }
    }
    
    
    func addTripObserverForUser() {
        guard let currentUser = currentUser else { return }
        tripService.addTripObserver(for: currentUser)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure (let error) = completion {
                    debugPrint("Error in addTripObserverForUser: \(error)")
                }
            } receiveValue: { trip in
                self.trip = trip
                self.updateTripTravelDetails()
            }
            .store(in: &cancellables)

    }
    
}


// MARK: - Rider API

extension HomeViewModel {
    
    func cancelTripReqest() {
        guard let tripRequest = self.riderRequest else { return }
        let updateTripRequest = UpdateTripRequest(state: .cancelled)
        tripService.updateTripRequest(id: tripRequest.id, update: updateTripRequest) { success in
            if success {
                self.riderRequest = nil
            }
        }
    }
    
    func addRiderRequestObserver() {
        guard let currentUser = currentUser, currentUser.accountType == .rider else { return }
        tripService.addTripRequestObserver(forRider: currentUser.uid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure (let error) = completion {
                    debugPrint("Error in observe rider request: \(error)")
                }
            } receiveValue: { request in
                self.riderRequest = request
            }
            .store(in: &cancellables)
    }
    
    
    func requestTrip(rideType: RideType) {
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedDropoffLocation else { return }
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        getUberLocationFromCLLocation(userLocation) { riderLocation in
            guard let riderLocation = riderLocation else { return }
            
            let tripCost = self.computeRidePrice(forType: rideType)
            let tripRequest = TripRequest(
                id: NSUUID().uuidString,
                riderUid: currentUser.uid,
                driverUid: nil,
                riderName: currentUser.firstname,
                driverName: nil,
                pickupLocation: riderLocation,
                dropoffLocation: dropoffLocation,
                tripCost: tripCost,
                rideType: rideType,
                state: .requested,
                seenBy: []
            )
            
            self.tripService.createTripRequest(tripRequest: tripRequest) { result in
                guard result != nil else { return }
                self.riderRequest = tripRequest
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
    
    
    func rejectTripRequest(request: TripRequest) {
        
        guard let currentUser = self.currentUser else { return }
        let updateTripRequest = UpdateTripRequest(seenBy: request.seenBy.appendIfNotContains(currentUser.uid))
        tripService.updateTripRequest(id: request.id, update: updateTripRequest) { success in
            if success {
                self.driverRequests.removeAll { tripRequest in
                    tripRequest.id == request.id
                }
            }
        }
    }
    
    
    func acceptTrip(request: TripRequest) {
        guard let currentUser = self.currentUser else { return }
        let updateTripRequest = UpdateTripRequest(
            driverUid: currentUser.uid,
            driverName: currentUser.firstname,
            seenBy: request.seenBy.appendIfNotContains(currentUser.uid),
            state: .accepted
        )
        tripService.updateTripRequest(id: request.id, update: updateTripRequest) { success in
            if success {
                self.driverRequests.removeAll { tripRequest in
                    tripRequest.id == request.id
                }
            }
        }
    }
    
    
    func startTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .ongoing)
        tripService.updateTrip(id: trip.id, update: updateTrip) { success in
            
        }
    }
    
    
    func completeTrip() {
        guard let trip = self.trip else { return }
        let updateTrip = UpdateTrip(state: .completed)
        tripService.updateTrip(id: trip.id, update: updateTrip) { success in
            
        }
    }
    
    func addDriverRequestsObserver() {
        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }
        
        tripService.fetchTripRequests(forDriver: currentUser.uid) { requests in
            self.driverRequests = requests
        }
        
        tripService.addTripRequestObserver(forDriver: currentUser.uid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure (let error) = completion {
                    debugPrint("Error in observe driver requests: \(error)")
                }
            } receiveValue: { request in
                debugPrint("Driver request change: \(request.state)")
                if request.state == .cancelled || request.state == .accepted {
                    self.driverRequests.removeAll { e in
                        e.id == request.id
                    }
                } else if request.seenBy.contains(currentUser.uid) {
                    self.driverRequests.removeAll { e in
                        e.id == request.id
                    }
                } else {
                    self.driverRequests = self.driverRequests.appendIfNotContains(request)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateTripTravelDetails() {
        guard let user = currentUser, user.accountType == .driver else { return }
        guard let trip = trip else { return }
        guard trip.travelDetails == nil else { return }
        
        var travelDetails = TravelDetails()
        let group = DispatchGroup()
        
        group.enter()
        getDestinationRoute(from: user.coordinates.toCLLocationCoordinate2D(), to: trip.pickupLocation.toCLLocationCoordinate2D()) { route in
            travelDetails.travelTimeToPickup = Int(route.expectedTravelTime / 60)
            travelDetails.distanceToPickup = route.distance
            group.leave()
        }
        
        group.enter()
        getDestinationRoute(from: trip.pickupLocation.toCLLocationCoordinate2D(), to: trip.dropoffLocation.toCLLocationCoordinate2D()) { route in
            travelDetails.travelTimeToDropoff = Int(route.expectedTravelTime / 60)
            travelDetails.distanceToDropoff = route.distance
            group.leave()
        }
        
        group.notify(queue: .main) {
            debugPrint("Travel Details: \(travelDetails)")
            let updateTrip = UpdateTrip(travelDetails: travelDetails)
            self.tripService.updateTrip(id: trip.id, update: updateTrip) { success in
                self.trip?.travelDetails = travelDetails
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
                debugPrint("Error searching for location: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            let uberLocation = UberLocation(title: localSearch.title, address: localSearch.subtitle, coordinate: UserCoordinates.from(coordinate: coordinate))
            
            switch config {
            case .ride(let viewModel):
                if viewModel == .pickup {
                    self.selectedPickupLocation = uberLocation
                } else {
                    self.selectedDropoffLocation = uberLocation
                }
               
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
            
            
            debugPrint("Location coordinates \(coordinate)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let dropoffCoordinate = selectedDropoffLocation?.coordinate else { return 0.0 }
        guard let pickupCoordinate = selectedPickupLocation?.coordinate else { return 0.0 }
        
        let userLocation = CLLocation(latitude: pickupCoordinate.latitude, longitude: pickupCoordinate.longitude)
        
        let destination = CLLocation(latitude: dropoffCoordinate.latitude, longitude: dropoffCoordinate.longitude)
        
        let tripDistanceInMeters = destination.distance(from: userLocation)
        return type.computePrice(for: tripDistanceInMeters)
        
    }
    
    func getDestinationRoute(from pickup: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: pickup)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                debugPrint("Error calculating directions: \(error.localizedDescription)")
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
