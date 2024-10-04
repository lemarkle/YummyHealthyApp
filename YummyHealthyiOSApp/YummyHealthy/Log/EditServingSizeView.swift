//
//  EditServingSizeView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/26/23.
//

import SwiftUI

struct EditServingSizeView: View {
    
    let caloriesPer100g: Int
    let proteinPer100g: Int
    let fatPer100g: Int
    let carbsPer100g: Int
    
    @Binding var option: ServingSizeOption
    @State var caloriesPerPortion: Int
    @State var proteinPerPortion: Int
    @State var fatPerPortion: Int
    @State var carbsPerPortion: Int
    
    init(caloriesPer100g: Int, proteinPer100g: Int, fatPer100g: Int, carbsPer100g: Int, option: Binding<ServingSizeOption>) {
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.fatPer100g = fatPer100g
        self.carbsPer100g = carbsPer100g
        self._option = option
        self.caloriesPerPortion = caloriesPer100g
        self.proteinPerPortion = proteinPer100g
        self.fatPerPortion = fatPer100g
        self.carbsPerPortion = fatPer100g
    }
    
    
    var body: some View {
            List {
                Section(header: Text("Portion detail")){
                    
                    LabeledContent {
                        TextField("ex. 100g", text: $option.value)
                            .multilineTextAlignment(.trailing)
                        
                    } label: {
                        
                        Label("Portion", systemImage: "textformat")
                    }
                    

                    
                }
                .headerProminence(.increased)
                
                Section(header: Text("Nutrition Data per Portion")){
                    LabeledContent {
                        TextField("kCal", value: $caloriesPerPortion, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                updateCounts(caloriesPerPortion, nutrition: "calories")
                            }
                    } label: {
                        
                        Label("Calories", systemImage: "flame")
                    }
                    
                    LabeledContent {
                        TextField("g", value: $proteinPerPortion, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                updateCounts(caloriesPerPortion, nutrition: "protein")
                            }
                              
                    } label: {
                        
                        Label("Protein", systemImage: "dumbbell")
                    }
                    
                    LabeledContent {
                        TextField("g", value: $fatPerPortion, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                updateCounts(caloriesPerPortion, nutrition: "fat")
                            }
                    } label: {
                        
                        Label("Fat", systemImage: "circle.hexagongrid")
                    }
                    LabeledContent {
                        TextField("g", value: $carbsPerPortion, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                updateCounts(caloriesPerPortion, nutrition: "carbs")
                            }
                    } label: {
                        
                        Label("Carb", systemImage: "laurel.trailing")
                    }
                    
                }
                .headerProminence(.increased)
            }
    }
    
    func updateCounts(_ newValue: Int, nutrition: String) {
        
        
        switch nutrition {
        case "calories":
            if caloriesPer100g == 0  {
                caloriesPerPortion = 0
                return
            }
            option.multiplier = Double(caloriesPerPortion) / Double(caloriesPer100g)
            proteinPerPortion =  Int(option.multiplier * Double(proteinPer100g))
            fatPerPortion =  Int(option.multiplier * Double(fatPer100g))
            carbsPerPortion =  Int(option.multiplier * Double(carbsPer100g))
        case "protein":
            if proteinPer100g == 0 {
                proteinPerPortion = 0
                return
            }
            
            option.multiplier = Double(proteinPerPortion) / Double(proteinPer100g)
            caloriesPerPortion =  Int(option.multiplier * Double(caloriesPer100g))
            fatPerPortion =  Int(option.multiplier * Double(fatPer100g))
            carbsPerPortion =  Int(option.multiplier * Double(carbsPer100g))
        case "fat":
            if fatPer100g == 0 {
                fatPerPortion = 0
                return
            }
            
            option.multiplier = Double(fatPerPortion) / Double(fatPer100g)
            caloriesPerPortion =  Int(option.multiplier * Double(caloriesPer100g))
            proteinPerPortion =  Int(option.multiplier * Double(proteinPer100g))
            carbsPerPortion =  Int(option.multiplier * Double(carbsPer100g))
        case "carbs":
            if carbsPer100g == 0 {
                carbsPerPortion = 0
                return
            }
            
            option.multiplier = Double(carbsPerPortion) / Double(carbsPer100g)
            caloriesPerPortion =  Int(option.multiplier * Double(caloriesPer100g))
            proteinPerPortion =  Int(option.multiplier * Double(proteinPer100g))
            fatPerPortion =  Int(option.multiplier * Double(fatPer100g))
            
        default:
            break
        }
    }
}

#Preview {
    EditServingSizeView(caloriesPer100g: 100, proteinPer100g: 50, fatPer100g: 100, carbsPer100g: 100, option: .constant(ServingSizeOption(value: "100g", multiplier: 1.0)))
}
