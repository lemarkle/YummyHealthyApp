
//
//  FoodView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/23/23.
//

import SwiftUI
import SwiftData

struct FoodView: View {
    @EnvironmentObject var vm: DataController
    @Environment(\.modelContext) var modelContext
    var entry: Entry
    @State var progress = 0.7
    @State private var consumeTime: Date
    @State private var numServing: Int
    @State private var servingSize: String
    @State private var editView = false
    
    init(entry: Entry) {
        _servingSize = State(wrappedValue: entry.servingSizeOption)
        _numServing = State(wrappedValue: entry.numServing)
        _consumeTime = State(wrappedValue: entry.consumeTime)
        self.entry = entry
    }
    
    
    var body: some View {
        
        ScrollView {
           
                LazyVStack {
                    
                    ZStack(alignment: .bottomLeading) {
                        Image("pizza")
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: UIScreen.main.bounds.size.width, minHeight: 400, maxHeight: 400)
                        Rectangle()
                            .fill(.thinMaterial)
                            .mask(LinearGradient(colors: [.clear,.clear,.black], startPoint: .top, endPoint: .bottom))
                        
                        HStack {
                            Text(entry.food?.name ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                            //.foregroundColor()
                            Spacer()
                            Button(action: {
                                editView.toggle()
                            }) {
                                Label("Edit", systemImage: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .sheet(isPresented: $editView, content: {
                                FoodEditView(id: entry.food?.id ?? UUID(), calories: entry.food?.calories ?? 0, protein: entry.food?.proteins ?? 0, fat: entry.food?.fat ?? 0, carbs: entry.food?.carbohydrates ?? 0, name: entry.food?.name ?? "", numServing: entry.numServing, servingSizeOption: ServingSizeOption(value: entry.servingSizeOption, multiplier: entry.servingSizeOptionMultiplier) ,options: entry.food?.servingSizeOptions.toOptions() ?? [])
                            })
                            
                        }
                        .padding(30)
                        
                        
                    }
                    .ignoresSafeArea()
                    .cornerRadius(50.0)
                    .cardBackground()
                    .padding(.bottom, 10)
                    

                    
                    Spacer()
                    
                    Text("% Daily Intake")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    ZStack(alignment: .center){
                        Rectangle()
                            .foregroundColor(.secondarySystemGroupedBackground)
                        
                        ScrollView(.horizontal) {
                            EqualWidthHStack {
                                
                            
                                VStack {
                                    Text("Calories")
                                        .fontWeight(.bold)
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 5))
                                            .frame(width: 60, height: 60)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: progress)
                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 60, height: 60)
                                            .onAppear {
                                                withAnimation{
                                                    progress = 0.7 // Change this value to set the progress (between 0.0 and 1.0)
                                                }
                                                
                                            }
                                        Text("70%")
                                        
                                    }
                                    
                                    Text("\(entry.food?.calories ?? 0)kCal")
                                }
                                .padding(15)
                
                                VStack {
                                    Text("Protein")
                                        .fontWeight(.bold)
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 5))
                                            .frame(width: 60, height: 60)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: progress)
                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 60, height: 60)
                                            .onAppear {
                                                withAnimation{
                                                    progress = 0.7 // Change this value to set the progress (between 0.0 and 1.0)
                                                }
                                                
                                            }
                                        Text("70%")
                                        
                                    }
                                    
                                    Text("\(entry.food?.proteins ?? 0)g")
                                }
                                .padding(15)
                                
                                VStack {
                                    Text("Carbs")
                                        .fontWeight(.bold)
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 5))
                                            .frame(width: 60, height: 60)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: progress)
                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 60, height: 60)
                                            .onAppear {
                                                withAnimation{
                                                    progress = 0.7 // Change this value to set the progress (between 0.0 and 1.0)
                                                }
                                                
                                            }
                                        Text("100%")
                                        
                                    }
                                    
                                    Text("\(entry.food?.carbohydrates ?? 0)g")
                                }
                                .padding(10)
                                VStack {
                                    Text("Fat")
                                        .fontWeight(.bold)
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 5))
                                            .frame(width: 60, height: 60)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: progress)
                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 60, height: 60)
                                            .onAppear {
                                                withAnimation{
                                                    progress = 0.7 // Change this value to set the progress (between 0.0 and 1.0)
                                                }
                                                
                                            }
                                        Text("100%")
                                        
                                    }
                                    
                                    Text("\(entry.food?.fat ?? 0)g")
                                }
                                .padding(10)
                                
                            }
                            .padding(.horizontal)
                            
                        }
                        
                        
                    }
                    .frame(minHeight: 150)
                    .cardBackground()
                    .padding(10)
                    
                    Text("Portion")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    ZStack(alignment: .center){
                        Rectangle()
                            .foregroundColor(.secondarySystemGroupedBackground)
                        
                        PortionPickerView(consumeTime: $consumeTime, numServing: $numServing, servingSize: $servingSize, entry: entry)
                        .padding(15)

                        
                    }
                    .frame(minHeight: 150)
                    .cardBackground()
                    .padding(10)
                }
            
        }
        .ignoresSafeArea(.all, edges: .top)
        .onDisappear {
            Task {
                guard let updatedEntry = await vm.updateEntry(id: entry.id, consumeTime: consumeTime, numServing: numServing, servingSizeOption: servingSize, servingSizeOptionMultiplier: entry.food?.servingSizeOptions[servingSize] ?? 1.0) else {return}
                entry.consumeTime = updatedEntry.consumeTime
                entry.servingSizeOption = updatedEntry.servingSizeOption
                entry.servingSizeOptionMultiplier = updatedEntry.servingSizeOptionMultiplier
                entry.numServing = updatedEntry.numServing
            }
        }
    }
    
}

#Preview {

    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)
        let example = Entry(id: UUID(), consumeTime: Date(), numServing: 2, servingSizeOption: "100g", servingSizeOptionMultiplier: 1.0)
        let food = Food(id: UUID(), name: "Pizza", calories: 100, proteins: 100, carbohydrates: 100, fat: 100, consumeTime: Date(), servingSizeOptions: ["100g": 1.0, "2 slices": 3.0], entries: [])
        container.mainContext.insert(food)
        example.food = food
        
        
        return FoodView(entry: example)
            .modelContainer(container)
            .environmentObject(DataController.preview)
        
    } catch {
        fatalError("Failed to create model container.")
    }

}
