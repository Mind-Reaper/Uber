//
//  RouteMapView.swift
//  Uber
//
//  Created by Daniel Onadipe on 4/12/25.
//

import MapKit
import SwiftUI

struct RouteMapView: UIViewRepresentable {
    let mapView = MKMapView()

    @EnvironmentObject var homeViewModel: HomeViewModel

    let pickupLocation: UberLocation
    let dropoffLocation: UberLocation

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.addAndSelectAnnonation()
        context.coordinator.configurePolyline()

    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension RouteMapView {
    class MapCoordinator: NSObject, MKMapViewDelegate {

        // MARK: - Properties

        let parent: RouteMapView

        // MARK: - Lifecycle

        init(parent: RouteMapView) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate

        func mapView(
            _ mapView: MKMapView, didUpdate userLocation: MKUserLocation
        ) {
            
//            addAndSelectAnnonation()
//            configurePolyline()

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
            if let annonation = annotation as? LocationAnnotation {
                let view = MKAnnotationView(
                    annotation: annotation, reuseIdentifier: "location")
                debugPrint("Location Annonation found: \(annonation.viewModel)")
                view.image = UIImage(
                    imageLiteralResourceName: annonation.viewModel == .pickup
                        ? "circle-annotation" : "square-annotation"
                )
                .resized(to: CGSize(width: 16, height: 16))

                return view
            }
            return nil
        }

        // MARK: - Helpers

        func addAndSelectAnnonation() {
            if parent.mapView.annotations.count > 1 {
                return
            }
            let pickupAnno = LocationAnnotation(
                coordinate: parent.pickupLocation.toCLLocationCoordinate2D(),
                viewModel: .pickup)
            let dropffAnno = LocationAnnotation(
                coordinate: parent.dropoffLocation.toCLLocationCoordinate2D(),
                viewModel: .dropoff)
            pickupAnno.coordinate = parent.pickupLocation
                .toCLLocationCoordinate2D()
            dropffAnno.coordinate = parent.dropoffLocation
                .toCLLocationCoordinate2D()
            parent.mapView.addAnnotations([pickupAnno, dropffAnno])

        }

        func configurePolyline() {
            
            guard self.parent.mapView.overlays.count == 0 else {
                return
            }

            let pickup = parent.pickupLocation.toCLLocationCoordinate2D()
            let dropoff = parent.dropoffLocation.toCLLocationCoordinate2D()
            parent.homeViewModel.getDestinationRoute(from: pickup, to: dropoff)
            { route in
                DispatchQueue.main.async {
                    if self.parent.mapView.overlays.count > 0 {
                        self.parent.mapView.removeOverlays(
                            self.parent.mapView.overlays)
                    }

                    self.parent.mapView.addOverlay(route.polyline)

                    let rect = self.parent.mapView.mapRectThatFits(
                        route.polyline.boundingMapRect,
                        edgePadding: .init(
                            top: 10, left: 60, bottom: 10, right: 60)
                    )
                    self.parent.mapView.setRegion(
                        MKCoordinateRegion(rect), animated: true)
                }
            }
        }

        func clearMapView(
            resetRegion: Bool = true, completion: (() -> Void)? = nil
        ) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            DispatchQueue.main.async {
                completion?()
            }

        }
    }
}



#Preview {
    RouteMapView(
        pickupLocation: Trip.empty().pickupLocation, dropoffLocation: Trip.empty().dropoffLocation
    )
    .environmentObject(HomeViewModel(userService: SupabaseUserService(), tripService: SupabaseTripService()))
}
