//
//  HomeView.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/21/23.
//

import SwiftUI
import Charts

struct HomeView: View {
    
    @State private var progress: CGFloat = 0.0
    let strokeWidth: CGFloat = 10
    var body: some View {
        NavigationView(content: {
            ScrollView{
                
                VStack {
                    Text("Today")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    NavigationLink(destination: Text("Destination")) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.secondarySystemGroupedBackground)
                            HStack {
                                Spacer()
                                VStack {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: strokeWidth))
                                            .frame(width: 150, height: 150)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: progress)
                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 150, height: 150)
                                            .onAppear {
                                                withAnimation{
                                                    progress = 0.7 // Change this value to set the progress (between 0.0 and 1.0)
                                                }
                                                
                                            }
                                        
                                        Text("\(Int(progress * 100))%")
                                            .font(.title)
                                    }
                                }
                                Spacer()
                                VStack {
                                    Text("Today Consumed")
                                    Text("700kCal")
                                    Text("")
                                    Text("Calories Left")
                                    Text("300kCal")
                                }
                                .foregroundColor(.primary)
                                Spacer()
                                
                            }
                        }
                        .cardBackground()
                        .frame(maxWidth: 1500, minHeight: 200, maxHeight: 200, alignment: .topLeading)
                        .padding(.all, 10)
                    }
                    Text("Quick Add")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    ForEach((1...3), id: \.self) { _ in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.secondarySystemGroupedBackground)
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
                                    //                                    .padding(.top)
                                    
                                    
                                }
                                .padding(10)
                                Spacer()
                                
                                Button {
                                    print("Edit button was tapped")
                                } label: {
                                    Image(systemName: "plus")
                                        .fontWeight(.bold)
                                }
                                .padding(20)
                            }
                            
                        }
                        .cardBackground()
                        .frame(maxWidth: 1500)
                        .padding(.all, 10)
                    }
                }
            }
            .navigationTitle("YummyHealthy")
        })
        
        
    }
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

// view extension for better modifier access
extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}

/// Data for the top style charts.
struct TopStyleData {
    /// Sales by pancake style for the last 30 days, sorted by amount.
    static let last30Days = [
        (name: "Cachapa", sales: 916, color: "blue"),
        (name: "Injera", sales: 820, color: "background"),
    ]
    
    /// Sales by pancake style for the last 12 months, sorted by amount.
    static let last12Months = [
        (name: "Cachapa", sales: 9631),
        (name: "Crêpe", sales: 6200),
        (name: "Injera", sales: 7891),
        (name: "Jian Bing", sales: 3300),
        (name: "American", sales: 700),
        (name: "Dosa", sales: 1400)
    ]
}

#Preview {
    HomeView()
}
