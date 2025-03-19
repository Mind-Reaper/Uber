//
//  LocationSearchViewModel.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import Foundation
import MapKit



enum LocationResultViewConfig {
    case ride
    case savedLocation(SavedLocationViewModel)
}

//class LocationSearchViewModel: NSObject, ObservableObject {
//    
//    
//    // MARK: - Properties
//    
//    @Published var results = [MKLocalSearchCompletion]()
//    @Published var selectedUberLocation: UberLocation?
//    @Published var pickupTime: Date?
//    @Published var dropoffTime: Date?
//    
//    private let searchCompleter = MKLocalSearchCompleter()
//    var queryFragment: String = "" {
//        didSet {
//            searchCompleter.queryFragment = queryFragment
//        }
//    }
//    
//    var userLocation: CLLocationCoordinate2D?
//    
//    override init() {
//        super.init()
//        searchCompleter.delegate = self
//        searchCompleter.queryFragment = queryFragment
//    }
//    
//    // MARK: - Helpers
//    
//    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultViewConfig) {
//        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
//            if let error = error {
//                print("DEBUG: Error searching for location: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let item = response?.mapItems.first else { return }
//            let coordinate = item.placemark.coordinate
//            let uberLocation = UberLocation(title: localSearch.title, subtitle: localSearch.subtitle, coordinate: UserCoordinates.from(coordinate: coordinate))
//            
//            switch config {
//            case .ride:
//                self.selectedUberLocation = uberLocation
//            case .savedLocation(let viewModel):
//                guard let uid = SupabaseManager.auth.currentUser?.id.uuidString else { return }
//                let savedLocation = SavedLocation.fromUberLocation(uberLocation)
//                
//                
//                let updateUser: UpdateUser
//                
//                if viewModel == .home {
//                     updateUser = UpdateUser(home: savedLocation)
//                } else {
//                     updateUser = UpdateUser(work: savedLocation)
//                }
//                                            
//                Task {
//                    try?  await SupabaseManager.table("users")
//                        .update(updateUser)
//                        .eq("uid", value: uid)
//                        .execute()
//                }
//            }
//            
//            
//            print("DEBUG: Location coordinates \(coordinate)")
//        }
//    }
//    
//    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
//        let search = MKLocalSearch(request: searchRequest)
//        
//        search.start(completionHandler: completion)
//    }
//    
//    func computeRidePrice(forType type: RideType) -> Double {
//        guard let coordinate = selectedUberLocation?.coordinate else { return 0.0 }
//        guard let userLocationCoordinate = self.userLocation else {return 0.0}
//        
//        let userLocation = CLLocation(latitude: userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
//        
//        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        
//        let tripDistanceInMeters = destination.distance(from: userLocation)
//        return type.computePrice(for: tripDistanceInMeters)
//        
//    }
//    
//    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,
//                             completion: @escaping (MKRoute) -> Void) {
//        let userPlacemark = MKPlacemark(coordinate: userLocation)
//        let destPlacemark = MKPlacemark(coordinate: destination)
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: userPlacemark)
//        request.destination = MKMapItem(placemark: destPlacemark)
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculate { response, error in
//            if let error = error {
//                print("Error calculating directions: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let route = response?.routes.first else {
//                return
//            }
//            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
//            
//            completion(route)
//        }
//    }
//    
//    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
//        pickupTime = Date()
//        dropoffTime = Date() + expectedTravelTime
//    }
//    
//    
//}
//
//
//// MARK: - MKLocalSearchCompleterDelegate Extension
//
//extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
//
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        self.results = completer.results
//    }
//    
//}
