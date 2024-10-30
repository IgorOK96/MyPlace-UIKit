//
//  AnnotationManager.swift
//  MyPlace
//
//  Created by user246073 on 10/29/24.
//

import Foundation
import MapKit

class AnnotationManager {
    func addAnnotation(for place: Place, on mapView: MKMapView, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let location = place.location else {
            completion(nil)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let placemark = placemarks?.first,
                  let placemarkLocation = placemark.location else {
                completion(nil)
                return
            }

            let annotation = PlaceAnnotation(place: place, coordinate: placemarkLocation.coordinate)

            DispatchQueue.main.async {
                mapView.addAnnotation(annotation)
                mapView.showAnnotations([annotation], animated: true)
            }

            completion(placemarkLocation.coordinate)
        }
    }
}
