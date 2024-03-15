//
//  TabbarView.swift
//  DemoApp
//
//  Created by Mayank on 15/03/24.
//

import SwiftUI

struct TabbarView: View {
    
    //MARK: - Variables
    @State private var selectedTab = 0
    
    //MARK: - Body
    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            LocationView()
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    Text("Location")
                }
                .tag(1)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(2)
        }
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

//MARK: - Preview
#Preview {
    TabbarView()
}

