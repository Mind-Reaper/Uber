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
    
    
    @Published var drivers: [AppUser] = []
    private let userService = SupabaseUserService.shared
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
    
    override init () {
        super.init()
        fetchAppUser()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    func fetchDrivers() {
        userService.fetchDrivers { drivers in
            if let drivers = drivers {
                self.drivers = drivers
            }
        }
    }
    
    func fetchAppUser() {
        
        userService.$user.sink { user in
            self.currentUser = user
            guard user?.accountType == .rider else { return }
            self.fetchDrivers()
        }
        .store(in: &cancellables)
    }
}


// MARK: - Rider API

extension HomeViewModel {
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedUberLocation else { return }
        
        
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        
        getUberLocationFromCLLocation(userLocation) { riderLocation in
            guard let riderLocation = riderLocation else { return }
        }
        
        let trip = Trip(
            id: NSUUID().uuidString,
            riderUid: currentUser.uid,
            driverUid: driver.uid,
            riderName: currentUser.firstname,
            driverName: currentUser.firstname,
            riderLocation: UberLocation(
                title: "Apple Campus",
                address: "123 Main Str",
                coordinate: currentUser.coordinates
            ),
            driverLocation: dropoffLocation,
            tripCost: 50.0,
            rideType: .black
        )
        
        
        SupabaseTripService.shared.createTrip(trip: trip) { result in
            
        }
        
    }
}


// MARK: - DriverAPI

extension HomeViewModel {
    
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
                title: placemark.name!, address: placemark.description, coordinate: UserCoordinates.from(coordinate: location.coordinate)
            )
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
