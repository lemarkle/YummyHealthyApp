//
//  LogView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/22/23.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @EnvironmentObject var vm: DataController
    @Query var entry: [Entry]
    @Environment(\.modelContext) var modelContext
    @State private var selectedDate = Date()
    
    @State private var progress: CGFloat = 0.0
    @State private var addFood = false
    
    let strokeWidth: CGFloat = 10
    
    var body: some View {
        NavigationView {
            ScrollView {
            
                LazyVStack {
                    DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Select a date")
                        }
                    .padding(15)
                    LogListingView(date: selectedDate)
                }
            
                
            }
            .navigationTitle("Log")
            .toolbar {
                Button(action: {
                    addFood.toggle()
                }) {
                    Label("Add", systemImage: "plus")
                }
                .sheet(isPresented: $addFood, content: AddFoodView.init)
                //Button("Add Samples", action: addSamples)
            }
        }
    }
//    func addSamples() {
//        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//        components.hour = 7 // 7 AM
//        components.minute = 0
//        guard let sevenAM = Calendar.current.date(from: components) else {return}
//        let pizza = Food(name: "Pizza", servingSize: 100, calories: 200, proteins: 20, carbohydrates: 30, fat: 10)
//        let pho = Food(name: "Pho", servingSize: 100, calories: 200, proteins: 20, carbohydrates: 30, fat: 10, consumeTime: sevenAM)
//        let steak = Food(name: "Steak", servingSize: 100, calories: 200, proteins: 20, carbohydrates: 30, fat: 10)
//        modelContext.insert(pizza)
//        modelContext.insert(pho)
//        modelContext.insert(steak)
//    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Food.self, configurations: config)
        let example = Entry()
        return LogView()
            .modelContainer(container)
            .environmentObject(DataController.preview)
    } catch {
        fatalError("Failed to create model container.")
    }
}
