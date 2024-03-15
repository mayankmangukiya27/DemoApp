//
//  GoogleMapView.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import Foundation
import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    var hospitals: [Hospital]
    @Binding var userLocation: CLLocation?
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator // Set delegate
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if let userLocation = userLocation {
            let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 12.0)
            uiView.animate(to: camera)
            
            // Display user's location with a circle overlay
            let circle = GMSCircle(position: userLocation.coordinate, radius: 5000)
            circle.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
            circle.strokeColor = .blue
            circle.strokeWidth = 1
            circle.map = uiView
        }
        
        for hospital in hospitals {
            let marker = GMSMarker(position: hospital.location.coordinate)
            marker.title = hospital.name
            marker.map = uiView
        
            if let userLocation = userLocation {
                let distance = userLocation.distance(from: hospital.location)
                let distanceInKilometers = Measurement(value: distance, unit: UnitLength.meters).converted(to: .kilometers)
                let distanceString = String(format: "%.1f km", distanceInKilometers.value)
                marker.snippet = distanceString
            }
        }
    }
    
    // Coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        // Handle tap on the info window of the marker
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            if let hospitalName = marker.title,
               let distanceString = marker.snippet {
                let shareText = "Hospital: \(hospitalName), Distance: \(distanceString)"
                
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
                    let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                    
                    if let viewController = UIApplication.shared.windows.first?.rootViewController {
                        viewController.present(activityViewController, animated: true, completion: nil)
                    }
                }
                alertController.addAction(shareAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                if let viewController = UIApplication.shared.windows.first?.rootViewController {
                    viewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
}
