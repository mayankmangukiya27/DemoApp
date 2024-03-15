//
//  LocationManager.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import Foundation
import SwiftUI
import CoreLocation


final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getUserLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch user location: \(error.localizedDescription)")
        completion?(nil)
    }
}
