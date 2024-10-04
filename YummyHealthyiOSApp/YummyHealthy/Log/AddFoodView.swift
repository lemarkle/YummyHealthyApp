//
//  AddFoodView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/24/23.
//

import SwiftUI

enum AddFoodMode {
    case camera
    case addDetail
    case search
}

struct AddFoodView: View {
    
    @State var mode: AddFoodMode = .search
    @State var searchQuery = ""
    @State var caloriesPerServing = "100"
    @Environment(\.dismiss) var dismiss
    
    @State var calories: Int = 0
    @State var protein: Int = 0
    @State var fat: Int = 0
    @State var carbs: Int = 0
    @State var name: String = ""
    
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Picker("Add Food Mode", selection: $mode) {
                    Text("Search").tag(AddFoodMode.search)
                    Text("Food Detail").tag(AddFoodMode.addDetail)
                    Text("Camera").tag(AddFoodMode.camera)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                
                switch mode {
                case .search:
                    
                    TextField("Search food", text: $searchQuery)
                        .padding(.horizontal, 10)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 30, alignment: .leading)
                        .background(Color.secondarySystemGroupedBackground)
                        .clipped()
                        .cornerRadius(10)
                        .padding()
                    Text("Quick Add")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    ForEach((1...3), id: \.self) { _ in
                        
                        HStack {
                            Image("pizza")
                                .resizable()
                                .frame(width: 70, height: 70, alignment: .leading)
                                .cardBackground()
                            
                            
                            VStack(alignment: .leading) {
                                Text("Pizza")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("1000 kCal")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                                                
                                
                            }
                            .padding(10)
                            Spacer()
                            
                            //Later
//                            NavigationLink(destination: FoodView.init) {
//                                Image(systemName: "pencil")
//                                    .fontWeight(.bold)
//                                
//                            }
//                            .padding(10)
                            
                            Button {
                                print("Edit button was tapped")
                            } label: {
                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                            }
                            .padding(10)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        
                        
                    }
                    
                    
                    
                case .addDetail:
                    FoodDataFormView(calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, name: $name)
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                case .camera:
                    CameraView()
                        .ignoresSafeArea()
                }
                Spacer()
            }
            .navigationTitle("Add food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
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
    
    
    
    func addFood(food: Food, token: String) {
        // Define the URL for the request
        guard let url = URL(string: "https://your-data-server.com/foods") else {
            print("Invalid URL")
            return
        }

        // Define the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add the token to the header

        // Encode the food data to JSON
        let encoder = JSONEncoder()
        guard let foodData = try? encoder.encode(food) else {
            print("Failed to encode food")
            return
        }

        // Set the request body
        request.httpBody = foodData

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Decode the response data
                let decoder = JSONDecoder()
                if let savedFood = try? decoder.decode(Food.self, from: data) {
                    print("Saved food: \(savedFood)")
                } else {
                    print("Invalid response")
                }
            }
        }

        task.resume()
    }
}

#Preview {
    AddFoodView()
}
