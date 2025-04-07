//
//  MapViewRepresentable.swift
//  Uber
//
//  Created by Daniel Onadipe on 2/23/25.
//

import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.resetLocations()
            context.coordinator.clearMapView()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            context.coordinator.resetLocations()
            context.coordinator.setCurrentLocation()
            context.coordinator.clearMapView()
            break
        case .locationSelected:
            if let pickup = homeViewModel.selectedPickupLocation,
                let dropoff = homeViewModel.selectedDropoffLocation
            {
                context.coordinator.shouldUpdateMapObjects(
                    pickup: pickup, dropoff: dropoff
                ) { allow in
                    if allow {
                        context.coordinator.clearMapView(resetRegion: false) {
                            context.coordinator.addAndSelectAnnonation()
                            context.coordinator.configurePolyline()
                              
                        }
                    }
                }

            }
            break
        case .tripAccepted(let pickup, let dropoff):
            context.coordinator.shouldUpdateMapObjects(
                pickup: pickup, dropoff: dropoff
            ) { allow in
                if allow {
                    context.coordinator.clearMapView(resetRegion: false) {
                        context.coordinator.addAndSelectAnnonation()
                        context.coordinator.configurePolyline()
                            
                    }
                }
            }
            break

        case .tripRequested(let pickup, let dropoff):
            context.coordinator.shouldUpdateMapObjects(
                pickup: pickup, dropoff: dropoff
            ) { allow in
                if allow {
                    context.coordinator.clearMapView(resetRegion: false) {
                        context.coordinator.addAndSelectAnnonation()
                        context.coordinator.configurePolyline()
                    }
                }
            }
            break
        case .tripCancelled:
            context.coordinator.resetLocations()
            context.coordinator.clearMapView()
            break
        }

    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {

        // MARK: - Properties

        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?

        var pickupLocation: UberLocation?
        var dropoffLocation: UberLocation?

        // MARK: - Lifecycle

        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate

        func mapView(
            _ mapView: MKMapView, didUpdate userLocation: MKUserLocation
        ) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, longitudeDelta: 0.05)
            )

            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)

        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
            -> MKOverlayRenderer
        {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(.foreground)
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation)
            -> MKAnnotationView?
        {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(
                    annotation: annotation, reuseIdentifier: annotation.uid)
                view.image = UIImage(
                    imageLiteralResourceName: "driver-annotation")
                return view
            }

            if let annonation = annotation as? LocationAnnotation {
                let view = MKAnnotationView(
                    annotation: annotation, reuseIdentifier: "location")
                debugPrint("Location Annonation found: \(annonation.viewModel)")
                view.image = UIImage(
                    imageLiteralResourceName: annonation.viewModel == .pickup
                        ? "circle-annotation" : "square-annotation"
                )
                .resized(to: CGSize(width: 20, height: 20))

                return view
            }

            return nil
        }

        // MARK: - Helpers

        func addAndSelectAnnonation() {
            if let pickup = self.pickupLocation?.toCLLocationCoordinate2D(), let dropoff = self.dropoffLocation?.toCLLocationCoordinate2D() {
                debugPrint("Annotations: \(parent.mapView.annotations)")
                if parent.mapView.annotations.count > 1 {
                    return
                }
                let pickupAnno = LocationAnnotation(
                    coordinate: pickup, viewModel: .pickup)
                let dropffAnno = LocationAnnotation(
                    coordinate: dropoff, viewModel: .dropoff)
                pickupAnno.coordinate = pickup
                dropffAnno.coordinate = dropoff
                parent.mapView.addAnnotations([pickupAnno, dropffAnno])
            }
        }

        func configurePolyline() {
            
            if let pickup = self.pickupLocation?.toCLLocationCoordinate2D(), let dropoff = self.dropoffLocation?.toCLLocationCoordinate2D() {
                parent.homeViewModel.getDestinationRoute(from: pickup, to: dropoff) { route in
                    DispatchQueue.main.async {
                        if self.parent.mapView.overlays.count > 0 {
                            self.parent.mapView.removeOverlays(
                                self.parent.mapView.overlays)
                        }
                        
                        self.parent.mapView.addOverlay(route.polyline)
                        
                        let rect = self.parent.mapView.mapRectThatFits(
                            route.polyline.boundingMapRect,
                            edgePadding: .init(
                                top: 64, left: 32, bottom: 500, right: 32))
                        self.parent.mapView.setRegion(
                            MKCoordinateRegion(rect), animated: true)
                    }
                }
            }
        }

        func clearMapView(
            resetRegion: Bool = true, completion: (() -> Void)? = nil
        ) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            if let currentRegion = currentRegion, resetRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }

            DispatchQueue.main.async {
                completion?()
            }

        }

        func addDriversToMap(_ drivers: [AppUser]) {
            let driverAnnotations = drivers.map { driver in
                DriverAnnotation(driver: driver)
            }
            self.parent.mapView.addAnnotations(driverAnnotations)
        }

        func setCurrentLocation() {
            guard self.parent.homeViewModel.selectedPickupLocation == nil else {
                return
            }
            guard let userLocationCoordinate = self.userLocationCoordinate
            else { return }
            let location = CLLocation(
                latitude: userLocationCoordinate.latitude,
                longitude: userLocationCoordinate.longitude)
            self.parent.homeViewModel.getUberLocationFromCLLocation(location) {
                currentLocation in
                if let currentLocation = currentLocation {
                    self.parent.homeViewModel.selectedPickupLocation =
                        currentLocation
                }

            }
        }
        
        func resetLocations() {
            self.pickupLocation = nil
            self.dropoffLocation = nil
        }

        func shouldUpdateMapObjects(
            pickup: UberLocation, dropoff: UberLocation,
            completion: @escaping (Bool) -> Void
        ) {
            guard pickup != pickupLocation || dropoff != dropoffLocation else {
                completion(false)
                return
            }
            self.pickupLocation = pickup
            self.dropoffLocation = dropoff

            completion(true)
        }

    }
}
