//
//  FoodDataFormView.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/2/24.
//

import SwiftUI

struct FoodDataFormView: View {
    var deleteFunc: (() -> Void)?
    @Binding var calories: Int
    @Binding var protein: Int
    @Binding var fat: Int
    @Binding var carbs: Int
    @Binding var name: String
    @State var numServing: Int = 1
    @State var servingSizeOption = ServingSizeOption(value: "100g", multiplier: 1.0)
    @State var options: [ServingSizeOption] = [ServingSizeOption(value: "100g", multiplier: 1.0)]
    @EnvironmentObject var vm: DataController
    @Environment(\.modelContext) var modelContext
    
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
                if (deleteFunc != nil) {
                    Section(header: Text("Delete")){
                        Button(action: deleteFunc!){
                            Label("Delete this food", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .toolbar {
                ToolbarItem{
                    Button(action: {
                        Task {
                            guard let food = await vm.addFood(name: name, calories: calories, proteins: protein, fat: fat, carbs: carbs, numServing: numServing, servingSizeOption: servingSizeOption.value, servingSizeOptionMultiplier: servingSizeOption.multiplier, options: options) else {return}
                            modelContext.insert(food)
                            for entry in food.entries {
                                entry.food = food
                            }

                        }
                    }, label: {
                        Text("Save")
                    })
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        FoodDataFormView(calories: .constant(500), protein: .constant(300), fat: .constant(200), carbs: .constant(50), name: .constant("Pizza"))
    }
}

class ServingSizeOption: ObservableObject, Hashable {
    static func == (lhs: ServingSizeOption, rhs: ServingSizeOption) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(value)
           hasher.combine(multiplier)
       }
    
    var id = UUID()
    @Published var value: String
    @Published var multiplier: Double
    init(value: String, multiplier: Double) {
        self.value = value
        self.multiplier = multiplier
    }
}
