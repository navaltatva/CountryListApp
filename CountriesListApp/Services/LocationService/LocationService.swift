//
//  LocationService.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import Foundation
import CoreLocation

// MARK: - Location Service
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userCountryCode: String?
    @Published var locationPermissionDenied = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let countryCode = placemarks?.first?.isoCountryCode {
                    self?.userCountryCode = countryCode
                } else {
                    self?.userCountryCode = "IN" // Default to India
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.userCountryCode = "IN" // Default to India
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationPermissionDenied = true
                self.userCountryCode = "IN" // Default to India
            }
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            DispatchQueue.main.async {
                self.userCountryCode = "IN" // Default to India
            }
        }
    }
}
