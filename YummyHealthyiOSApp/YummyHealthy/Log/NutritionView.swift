//
//  NutritionView.swift
//  YummyHealthy
//
//  Created by Mark Le on 11/22/23.
//

import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var vm: DataController
    
    var body: some View {
        VStack {
            Text("Calories: \(vm.caloriesPerServing)")
            Text("Name: \(vm.description)")
            Text("Barcode \(vm.barcode)")
        }
    }
}

#Preview {
    NutritionView()
        .environmentObject(DataController.preview)
}
