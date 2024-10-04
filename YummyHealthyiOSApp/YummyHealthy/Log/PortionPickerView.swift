//
//  PortionPickerView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/26/23.
//

import SwiftUI
import SwiftData

struct PortionPickerView: View {
    @Binding var consumeTime: Date
    @Binding var numServing: Int
    @Binding var servingSize: String
    var entry: Entry
    var body: some View {
        Grid(alignment:.leading) {
            GridRow {
                Text("Consume Time")
                Spacer()
                DatePicker("", selection: $consumeTime, in: ...Date.now, displayedComponents: [.hourAndMinute, .date])
                    .frame(width: 200)
                .gridColumnAlignment(.trailing)
            }
            
            GridRow {
                Text("Portion")
                Spacer()
                
                Picker("", selection: $servingSize) {
                    let keys = entry.food?.servingSizeOptions.map {$0.key} ?? []
                    let values = entry.food?.servingSizeOptions.map {$0.value} ?? []
                    ForEach(keys.indices, id: \.self) { index in
                        Text(keys[index])
                            .tag(keys[index])
                    }
                }
                .pickerStyle(.menu)
                .gridColumnAlignment(.trailing)
            }
            GridRow {
                Text("Num serving")
                Spacer()
                Picker("", selection: $numServing) {
                    ForEach(0...10, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }
                .pickerStyle(.menu)
                .gridColumnAlignment(.trailing)
                    
            }
        
        }
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)
        let example = Entry(id: UUID(), consumeTime: Date(), numServing: 2, servingSizeOption: "100g", servingSizeOptionMultiplier: 1.0)
        let food = Food(id: UUID(), name: "Pizza", calories: 100, proteins: 100, carbohydrates: 100, fat: 100, consumeTime: Date(), servingSizeOptions: ["100g": 1.0], entries: [])
        container.mainContext.insert(food)
        example.food = food
        

        return PortionPickerView(consumeTime: .constant(.now), numServing: .constant(1), servingSize: .constant("100g"), entry: example)
            .modelContainer(container)
            .previewLayout(.sizeThatFits)
     } catch {
         fatalError("Failed to create model container.")
     }
}
