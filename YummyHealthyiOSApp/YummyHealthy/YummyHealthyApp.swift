//
//  YummyHealthyApp.swift
//  YummyHealthy
//
//  Created by Mark Le on 11/22/23.
//

import SwiftUI

@main
struct YummyHealthyApp: App {
    @StateObject private var vm = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
        .modelContainer(for: Food.self)
        .modelContainer(for: Entry.self)
    }
}
