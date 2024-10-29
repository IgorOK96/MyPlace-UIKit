//
//  MapManager.swift
//  MyPlace
//
//  Created by user246073 on 10/29/24.
//

import UIKit
import MapKit

final class MapManager {
    
    let locationManager = CLLocationManager()
    
    private var placeCoordinate: CLLocationCoordinate2D?
    private let regionMeters = 2_000.00
    private var directionsArray: [MKDirections] = []

    private func setupPlacemark(place: Place, mapView: MKMapView) {
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLocationServices(mapView: MKMapView, segueIdentifier: String, clouser: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            clouser()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Services ae Disbled",
                    message: "To enabled it go: Settings -> Privacy -> Location Services and turn On"
                )
            }
        }
    }
    
    private func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" { showUserLocaton() }
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Доступ к местоположению отключен",
                    message: "Пожалуйста, включите доступ к местоположению в настройках, чтобы использовать все функции приложения."
                )
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Доступ к местоположению ограничен",
                    message: "Ваше устройство ограничивает доступ к местоположению для этого приложения. Пожалуйста, свяжитесь с администратором устройства или измените настройки."
                )
            }
        case .authorizedAlways: break
        @unknown default:
            break
        }
    }


    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController( title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true)

    }
}
