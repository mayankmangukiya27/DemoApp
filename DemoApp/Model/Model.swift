//
//  Model.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct Hospital {
    let name: String
    let location: CLLocation
}

struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]
}

struct GooglePlace: Codable {
    let name: String
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

