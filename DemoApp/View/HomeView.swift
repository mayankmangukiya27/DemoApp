//
//  HomeView.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct HomeView: View {
    
    //MARK: - Variables
    @State private var hospitals: [Hospital] = []
    @State private var userLocation: CLLocation?
    @State private var isShowingUserLocationErrorAlert = false
    @State private var searchText: String = ""
    
    //MARK: - Body
    var body: some View {
        VStack {
            GoogleMapView(hospitals: hospitals, userLocation: $userLocation)
                .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            fetchUserLocation()
        }
        .alert(isPresented: $isShowingUserLocationErrorAlert) {
            Alert(title: Text("Location Error"), message: Text("Failed to fetch user's location. Please enable location services in Settings."), dismissButton: .default(Text("OK")))
        }
    }
    
    private func fetchUserLocation() {
        LocationManager.shared.getUserLocation { location in
            if let location = location {
                self.userLocation = location
                self.fetchNearbyHospitals()
            } else {
                self.isShowingUserLocationErrorAlert = true
            }
        }
    }
    
    func fetchNearbyHospitals() {
        guard let userLocation = userLocation else { return }
        
        // Set up URL components for Google Places API nearby search
        var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")!
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"),
            URLQueryItem(name: "radius", value: "5000"),
            URLQueryItem(name: "type", value: "hospital"),
            URLQueryItem(name: "key", value: "AIzaSyCPuqReF7izEd06E8CAnAEdfI-_sLrXkvM")
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL for Google Places API")
            return
        }
        
        // Create a URL session and data task to fetch nearby hospitals
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch nearby hospitals: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GooglePlacesResponse.self, from: data)
                
                let hospitals = response.results.map { Hospital(name: $0.name, location: CLLocation(latitude: $0.geometry.location.lat, longitude: $0.geometry.location.lng)) }
                
                DispatchQueue.main.async {
                    self.hospitals = hospitals
                }
            } catch {
                print("Failed to decode JSON response: \(error.localizedDescription)")
            }
        }.resume()
    }
}

//MARK: - Preview
#Preview {
    HomeView()
}
