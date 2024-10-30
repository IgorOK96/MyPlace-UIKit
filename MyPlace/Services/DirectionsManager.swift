//
//  DirectionsManager.swift
//  MyPlace
//
//  Created by user246073 on 10/29/24.
//
import Foundation
import MapKit

class DirectionsManager {
    var directionsArray: [MKDirections] = []
    var routes: [MKRoute] = []
    var routeColors: [MKPolyline: UIColor] = [:]
    var mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
    }

    func getDirections(from sourceCoordinate: CLLocationCoordinate2D,
                       to destinationCoordinate: CLLocationCoordinate2D,
                       completion: @escaping (Result<Void, Error>) -> Void) {
        let request = createDirectionsRequest(from: sourceCoordinate, to: destinationCoordinate)
        let directions = MKDirections(request: request)
        resetMapView()
        directionsArray.append(directions)

        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response else {
                let error = NSError(domain: "DirectionsError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Маршрут не найден"])
                completion(.failure(error))
                return
            }

            self.routes = response.routes

            let colors: [UIColor] = [.black, .cyan, .orange] // Поменял порядок, чтобы оранжевый маршрут был сверху
            for (index, route) in self.routes.enumerated() {
                let color = colors[index % colors.count]
                self.routeColors[route.polyline] = color
                self.mapView.addOverlay(route.polyline)
            }
            completion(.success(()))
        }
    }

    private func resetMapView() {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.forEach { $0.cancel() }
        directionsArray.removeAll()
        routeColors.removeAll()
    }

    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true

        return request
    }
}
