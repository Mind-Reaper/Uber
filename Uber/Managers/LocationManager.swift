//
//  LocationManager.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import CoreLocation


class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    private let locationQueue = DispatchQueue(label: "com.yourapp.locationQueue", qos: .userInitiated)
    
    private var hasRequestedAuthorization = false
    
    override init() {
        super.init()
        locationQueue.async { [weak self] in
            guard let self = self else {return}
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if !self.hasRequestedAuthorization {
                self.locationManager.requestWhenInUseAuthorization()
                self.hasRequestedAuthorization = true
            }
        }
        startLocaationUpdates()
    }
    

 
    func startLocaationUpdates() {
        locationQueue.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationUpdates() {
        locationQueue.async { [weak self] in
            self?.locationManager.stopUpdatingLocation()
        }
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        
        DispatchQueue.main.async { [weak self] in
            self?.userLocation = location.coordinate
        }

        self.stopLocationUpdates()

    }
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle authorization changes if needed
    }
