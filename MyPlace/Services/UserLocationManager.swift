//
//  UserLocationManager.swift
//  MyPlace
//
//  Created by user246073 on 10/29/24.
//

import Foundation
import CoreLocation

protocol UserLocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: Error)
    func userLocationManager(didChangeAuthorization status: CLAuthorizationStatus)

}

final class UserLocationManager: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: UserLocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Обработка ситуации, когда сервисы местоположения отключены
            delegate?.didFailWithError(NSError(domain: "Location services are disabled", code: 1, userInfo: nil))
        }
    }

    private func checkLocationAuthorization() {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                delegate?.userLocationManager(didChangeAuthorization: locationManager.authorizationStatus)
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                delegate?.userLocationManager(didChangeAuthorization: locationManager.authorizationStatus)
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                break
            }
        }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension UserLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didUpdateLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }
}


extension UserLocationManager {
    var currentLocation: CLLocation? {
        return locationManager.location
    }
}
