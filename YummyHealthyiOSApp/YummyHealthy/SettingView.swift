//
//  SettingView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/22/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var vm: DataController
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    Button(action: vm.logout, label: {
                        Label("Sign out", systemImage: "person")
                    })
                    NavigationLink(destination: {
                        
                    }) {
                        Label("Edit Account", systemImage: "person")
                    }
                }
                .headerProminence(.increased)
                Section(header: Text("Goals")) {
                    NavigationLink(destination: {
                        
                    }) {
                        Label("Edit Nutrition Goal", systemImage: "chart.bar")
                    }
                }
                .headerProminence(.increased)
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    SettingView()
}
