//
//  FoodEditView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/24/23.
//

import SwiftUI

struct FoodEditView: View {
    
    @EnvironmentObject var vm: DataController
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var id: UUID
    @State var calories: Int
    @State var protein: Int
    @State var fat: Int
    @State var carbs: Int
    @State var name: String
    @State var numServing: Int
    @State var servingSizeOption: ServingSizeOption
    @State var options: [ServingSizeOption]
    
    
    var body: some View {
        NavigationStack {
            List {
                
            
                        Section(header: Text("Nutrition Data")){
                            LabeledContent {
                                TextField("kCal", value: $calories, formatter: NumberFormatter())
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                
                                Label("Calories", systemImage: "flame")
                            }
                            
                            LabeledContent {
                                TextField("g", value: $protein, formatter: NumberFormatter())
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                
                                Label("Protein", systemImage: "dumbbell")
                            }
                            
                            LabeledContent {
                                TextField("g", value: $fat, formatter: NumberFormatter())
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                
                                Label("Fat", systemImage: "circle.hexagongrid")
                            }
                            LabeledContent {
                                TextField("g", value: $carbs, formatter: NumberFormatter())
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                
                                Label("Carb", systemImage: "laurel.trailing")
                            }
                            
                        }
                        .headerProminence(.increased)
                        
                        
                        Section(header:
                        HStack {
                            Text("Portion")
                            Spacer()
                            NavigationLink(destination: {
                                List {
                                    Section(header: Text("Serving Size")){
                                        ForEach($options, id: \.id) { $option in
                                            NavigationLink {
                                                EditServingSizeView(caloriesPer100g: calories, proteinPer100g: protein, fatPer100g: fat, carbsPer100g: carbs, option: $option)
                                            } label: {
                                                Label(option.value, systemImage: "chart.pie")
                                            }
                                            
                                        }
                                        Button(action: {
                                            options.append(ServingSizeOption(value: "1 unit", multiplier: 1.0))
                                        }, label: {
                                            Label("Add serving size", systemImage: "plus")
                                        })
                                        
                                    }
                                    .headerProminence(.increased)
                                }
                            }, label: {Text("Edit")})
                        }
                        ){
                            LabeledContent {
                                Picker("", selection: $servingSizeOption) {
                                    ForEach(options, id: \.self) {
                                        Text($0.value)
                                            .tag($0)
                                    }
                                    
                                }
                                .frame(height: 30)
                            } label: {
                                
                                Label("Serving size", systemImage: "chart.pie")
                            }
                            
                            LabeledContent {
                                Picker("", selection: $numServing) {
                                    ForEach(1...20, id: \.self) {
                                        Text("\($0)")
                                            .tag($0)
                                    }
                                    
                                }
                                .frame(height: 30)
                            } label: {
                                
                                Label("Num serving", systemImage: "textformat.123")
                            }
                        }
                        .headerProminence(.increased)
                        
                        
                        Section(header: Text("Food Detail")){
                            LabeledContent {
                                TextField("", text: $name)
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                
                                Label("Food Name", systemImage: "textformat")
                            }
                            
                            Label("Image", systemImage: "photo")
                            
                            ZStack(alignment: .bottomLeading) {
                                Image("pizza")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                Rectangle()
                                    .fill(.thinMaterial)
                                    .mask(LinearGradient(colors: [.clear,.clear,.black], startPoint: .top, endPoint: .bottom))
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        print("edit")
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                }
                                .padding(25)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                            
                        }
                        .headerProminence(.increased)

                    }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem{
                    Button(action: save, label: {
                        Text("Save")
                    })
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                
            }
        }
    }
    
    
    func save() {
        Task {
            guard let food = await vm.updateFood(id: id, name: name, calories: calories, proteins: protein, fat: fat, carbs: carbs, options: options) else { return }
            modelContext.insert(food)
            dismiss()
        }
    }
    
}

#Preview {
    FoodEditView(id: UUID(), calories: 500, protein: 300, fat: 200, carbs: 50, name: "Pizza", numServing: 2, servingSizeOption: ServingSizeOption(value: "100g", multiplier: 1.0), options: [ServingSizeOption(value: "100g", multiplier: 1.0)])
}
