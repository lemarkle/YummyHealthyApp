//
//  ContentView.swift
//  YummyHealthy
//
//  Created by Mark Le on 11/22/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var vm: DataController
    @SceneStorage("selectedView") var selectedView: String?
    var body: some View {
        if vm.isLoggedIn {
            TabView(selection: $selectedView){
                HomeView()
                    .tag("HomeView")
                    .tabItem { Label("Home", systemImage: "house") }
                LogView()
                    .tag("LogView")
                    .tabItem { Label("Log", systemImage: "pencil") }
                SettingView()
                    .tag("SettingView")
                    .tabItem { Label("Setting", systemImage: "gear") }
                TestView()
                    .tag("TestView")
                    .tabItem { Label("Test", systemImage: "camera") }
            }
            .onAppear {
                Task {
                    let foods = await vm.fetchAllFood()
                    for food in foods {
                        modelContext.insert(food)
                    }
                    
                    for food in foods {
                        for entry in food.entries {
                            entry.food = food
                        }
                    }
                    try modelContext.save()
                }
                
            }
        } else {
            LoginView(isLoggedIn: $vm.isLoggedIn)
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(DataController.preview)
}
