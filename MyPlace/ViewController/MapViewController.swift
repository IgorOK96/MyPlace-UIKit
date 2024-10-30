//
//  MapViewController.swift
//  MyPlace
//
//  Created by user246073 on 10/28/24.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func getAddress(_ address: String?)
}

final class MapViewController: UIViewController {
    var place = Place()
    weak var mapViewControllerDelegate: MapViewControllerDelegate?
    
    // Менеджеры
    var locationManager: UserLocationManager!
    var annotationManager: AnnotationManager!
    var directionsManager: DirectionsManager!
    
    // Свойства
    var placeCoordinate: CLLocationCoordinate2D?
    let regionMeters = 2000.00
    var previousLocation: CLLocation?
    var incomeSegueIdentifier = ""
    
    // IBOutlet
    @IBOutlet var goButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagers()
        setupMapView()
    }
    
    private func setupManagers() {
        // Инициализация менеджеров
        locationManager = UserLocationManager()
        locationManager.delegate = self
        
        annotationManager = AnnotationManager()
        directionsManager = DirectionsManager(mapView: mapView)
        
        // Настройка карты
        mapView.delegate = self
        locationManager.checkLocationServices()
    }
    
    private func setupMapView() {
        addressLabel.text = ""
        goButton.isHidden = true
        
        if incomeSegueIdentifier == "showPlace" {
            annotationManager.addAnnotation(for: place, on: mapView) { [weak self] coordinate in
                guard let self = self, let coordinate = coordinate else { return }
                self.placeCoordinate = coordinate
            }
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    @IBAction func centerViewUser() {
        if let location = locationManager.currentLocation {
            centerMapOnLocation(location.coordinate)
        }
    }
    
    @IBAction func doneButtonAction() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func goButtonAction() {
        guard let userCoordinate = locationManager.currentLocation?.coordinate,
              let destinationCoordinate = placeCoordinate else {
            showAlert(title: "Ошибка", message: "Местоположение не найдено")
            return
        }
        
        directionsManager.getDirections(from: userCoordinate, to: destinationCoordinate) { [weak self] result in
            switch result {
            case .success:
                // Если нужно, можно добавить обработку успешного результата
                break
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionMeters,
            longitudinalMeters: regionMeters
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController( title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

// MARK: - UserLocationManagerDelegate
extension MapViewController: UserLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        previousLocation = location
        if incomeSegueIdentifier == "getAddress" {
            centerMapOnLocation(location.coordinate)
        }
    }
    
    func didFailWithError(_ error: Error) {
        showAlert(title: "Ошибка", message: error.localizedDescription)
    }
    
    func userLocationManager(didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            // Если нужно, центрируйте карту на местоположении пользователя
            if let location = locationManager.currentLocation {
                centerMapOnLocation(location.coordinate)
            }
        case .denied, .restricted:
            showAlert(
                title: "Доступ к местоположению запрещен",
                message: "Разрешите доступ в настройках"
            )
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                self.centerViewUser()
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else { return }
            
            let streetName = placemark.thoroughfare ?? ""
            let buildNumber = placemark.subThoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetName) \(buildNumber)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 5
            
            if let color = directionsManager.routeColors[polyline] {
                renderer.strokeColor = color
            } else {
                renderer.strokeColor = .black
            }
            
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Проверяем, что аннотация не является текущим местоположением пользователя
        if annotation is MKUserLocation {
            return nil
        }
        
        return AnnotationViewFactory.createAnnotationView(for: annotation, on: mapView)
    }
}




