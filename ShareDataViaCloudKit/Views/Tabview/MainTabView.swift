//
//  File.swift
//  MacroApp
//
//  Created by luis fontinelles on 07/10/24.
//

import SwiftUI

struct MainTabView: View {
    var room: Room
    
    var body: some View {
        TabView {
            HomeView(room: room)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            DailyView()
                .tabItem {
                    Label("Daily", systemImage: "sun.max")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
