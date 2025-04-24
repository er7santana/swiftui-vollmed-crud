//
//  ContentView.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label(
                    title: { Text("Home") },
                    icon: { Image(systemName: "house") }
                )
            }
            
            NavigationView {
                MyAppointmentsView()
            }
            .tabItem {
                Label(
                    title: { Text("Minhas consultas") },
                    icon: { Image(systemName: "calendar") }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
