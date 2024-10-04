//
//  MealCardView.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/29/24.
//

import SwiftUI

struct MealCardView: View {
    
    @EnvironmentObject var vm: DataController
    @Environment(\.modelContext) var modelContext
    var entries: [Entry]
    var totalCalories: Int
    
    init(entries: [Entry]) {
        self.entries = entries
        var sum = 0
        for entry in entries {
            sum += entry.food?.calories ?? 0
        }
        totalCalories = sum
    }
    
    var body: some View {
        ZStack(alignment:.leading){
            Rectangle()
                .foregroundColor(.secondarySystemGroupedBackground)
            VStack(alignment: .leading) {
                HStack {
                    Text("Calories")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(totalCalories) kCal – 70%")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                }
                ProgressView(value: 0.7)
                    .padding()
                
                Text("Food")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                ForEach(entries, id: \.self) { entry in
                    
                    HStack {
                        Image("pizza")
                            .resizable()
                            .frame(width: 70, height: 70, alignment: .leading)
                            .cardBackground()
                        
                        
                        VStack(alignment: .leading) {
                            Text(entry.food?.name ?? "")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(entry.food?.calories ?? 0) kCal")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            
                        }
                        .padding(10)
                        Spacer()
                        
                        
                        NavigationLink(destination: {
                            FoodView(entry: entry)
                        }) {
                            Image(systemName: "pencil")
                                .fontWeight(.bold)
                            
                        }
                        .padding(20)
                        
                        Button(action: {
                            Task {
                                if await vm.deleteEntry(entry: entry) {
                                    modelContext.delete(entry)
                                    try modelContext.save()
                                }
                            }
                        }, label: {
                            Image(systemName: "trash")
                                .fontWeight(.bold)
                        })
                    }
                    
                    
                }
            }
            .padding()
            
        }
        .cardBackground()
        .padding(10)
    }
}
