//
//  PlaceAnnotation.swift
//  MyPlace
//
//  Created by user246073 on 10/30/24.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let imageData: Data?

    init(place: Place, coordinate: CLLocationCoordinate2D) {
        self.title = place.name
        self.subtitle = place.type
        self.coordinate = coordinate
        self.imageData = place.imageData
        super.init()
    }
}
