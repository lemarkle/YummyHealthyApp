//
//  TestView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/22/23.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @EnvironmentObject var vm: DataController
    @Query var entries: [Entry]
    @Query var foods: [Food]
   
    var body: some View {
        NavigationStack {
            VStack {
                NutritionView()
                    .navigationTitle("YummyHealthy")
                    .toolbar {
                        Button(action: {
                            vm.cameraSheet.toggle()
                        }, label: {
                            Label("Add", systemImage: "camera")
                        })
                    }
                Text("\(entries.count)")
                Text("\(foods.count)")
                ForEach(foods) {
                    ForEach($0.entries) { entry in
                        Text(entry.food?.name ?? "Abc")
                    }
                        
                }
                
                ForEach(entries) { entry in
                    let keys = entry.food?.servingSizeOptions.map {$0.key} ?? []
                    let values = entry.food?.servingSizeOptions.map {$0.value} ?? []
                    VStack {
                        Text(entry.food?.name ?? "")
                        Text("\(entry.servingSizeOption)")
                        Text("\(entry.numServing)")
                        Text("\(entry.food?.calories ?? 0)")
                        Text("\(entry.food?.id ?? UUID())")
                        Text("\(entry.id)")
                        Text("\(entry.consumeTime)")
                        ForEach(keys.indices) { index in
                            HStack {
                                Text(keys[index])
                                Text("\(values[index])")
                            }
                        }
                    }
                }
                
            }
            
        }
        .sheet(isPresented: $vm.cameraSheet, content: CameraView.init)
    }
}

#Preview {
    TestView()
        .environmentObject(DataController.preview)
}
