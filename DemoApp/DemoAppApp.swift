//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleMaps

@main
struct DemoAppApp: App {
    
    //MARK: - Variables
    @StateObject var auth: UserAuthModel = UserAuthModel()
    
    //MARK: - Init Method
    init(){
        setupAuthentication()
        setupGoogleMaps()
    }
    
    //MARK: - Body
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onReceive(auth.$isLoggedIn) { isLoggedIn in
                    if isLoggedIn {
                        openTabBarView()
                    }
                }
        }
        .environmentObject(auth)
    }
    
    //MARK: - Functions
    func openTabBarView() {
        let tabBarView = TabbarView()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: tabBarView)
            window.makeKeyAndVisible()
        }
    }
    
    func setupGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyCPuqReF7izEd06E8CAnAEdfI-_sLrXkvM")
    }
}


//MARK: - Extensions
extension DemoAppApp {
    private func setupAuthentication(){
        FirebaseApp.configure()
    }
}
