//
//  LogListingView.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/26/24.
//

import SwiftUI
import SwiftData

struct LogListingView: View {
    @EnvironmentObject var vm: DataController
    @Environment(\.modelContext) var modelContext
    @Query var midnightMeal: [Entry]
    @Query var morningMeal: [Entry]
    @Query var dinnerMeal: [Entry]
    
    init(date: Date) {
        _midnightMeal = Query(filter: Entry.midnightFilter(date: date), sort: \Entry.consumeTime)
        _morningMeal = Query(filter: Entry.breakfastFilter(date: date), sort: \Entry.consumeTime)
        _dinnerMeal = Query(filter: Entry.dinnerFilter(date: date), sort: \Entry.consumeTime)
    }
    
    var body: some View {
        MealCardView(entries: midnightMeal)
        MealCardView(entries: morningMeal)
        MealCardView(entries: dinnerMeal)
        
    }
}

#Preview {
    LogListingView(date: Date())
}
