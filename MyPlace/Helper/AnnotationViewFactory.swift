//
//  AnnotationViewFactory.swift
//  MyPlace
//
//  Created by user246073 on 10/30/24.
//

import MapKit

final class AnnotationViewFactory {
    static func createAnnotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }
        let annotationIdentifier = "PlaceAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true

            // Настройка булавки
            annotationView?.markerTintColor = .systemBlue
            annotationView?.glyphText = "📍"

            // Добавление фото
            if let imageData = placeAnnotation.imageData {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.layer.cornerRadius = 10
                imageView.clipsToBounds = true
                imageView.image = UIImage(data: imageData)
                annotationView?.leftCalloutAccessoryView = imageView
            }

            // Добавление кнопки информации
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = placeAnnotation
        }

        return annotationView
    }
}
