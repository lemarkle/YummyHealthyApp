//
//  DataModel.swift
//  YummyHealthy
//
//  Created by Mark Le on 12/25/23.
//

import Foundation
import SwiftData



class User {
    
    static let example = User(name: "Mark Le", email: "abc@gmail.com", avatar: "", caloriesGoal: 1000, proteinsGoal: 180, carbohydratesGoal: 500, fatGoal: 200)
    
    var name: String
    var email: String
    var avatar: String
    var caloriesGoal: Int
    var proteinsGoal: Int
    var carbohydratesGoal: Int
    var fatGoal: Int
    
    init(name: String, email: String, avatar: String, caloriesGoal: Int, proteinsGoal: Int, carbohydratesGoal: Int, fatGoal: Int) {
        self.name = name
        self.email = email
        self.avatar = avatar
        self.caloriesGoal = caloriesGoal
        self.proteinsGoal = proteinsGoal
        self.carbohydratesGoal = carbohydratesGoal
        self.fatGoal = fatGoal
    }
    
}

struct ServingSizeOptionData: Codable {
    var value: String
    var multiplier: Double
}


@Model
class Food: Codable {
    
    
    
    enum CodingKeys: CodingKey {
        case id, name, calories, proteins, carbohydrates, fat, servingSizeOptions, entries
    }
    static var example = Food(id: UUID(), name: "Pizza", calories: 200, proteins: 20, carbohydrates: 30, fat: 10)
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Int
    var proteins: Int
    var carbohydrates: Int
    var fat: Int
    @Relationship(deleteRule: .cascade, inverse: \Entry.food) var entries: [Entry]
    
    var servingSizeOptions: [String: Double]
    
    init(id: UUID = UUID(), name: String, calories: Int, proteins: Int, carbohydrates: Int, fat: Int, consumeTime: Date = Date(), servingSizeOptions:[String: Double] = [:], entries: [Entry] = [] ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.servingSizeOptions = servingSizeOptions
        self.entries = entries
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Int.self, forKey: .calories)
        proteins = try container.decode(Int.self, forKey: .proteins)
        carbohydrates = try container.decode(Int.self, forKey: .carbohydrates)
        fat = try container.decode(Int.self, forKey: .fat)
        entries = try container.decode([Entry].self, forKey: .entries)
        servingSizeOptions = [:]
        let options = try container.decode([ServingSizeOptionData].self, forKey: .servingSizeOptions)
        
        for option in options {
            servingSizeOptions[option.value] = option.multiplier
        }
        
        
        
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(calories, forKey: .calories)
        try container.encode(proteins, forKey: .proteins)
        try container.encode(carbohydrates, forKey: .carbohydrates)
        try container.encode(fat, forKey: .fat)
        
        var options = [ServingSizeOptionData]()
        for option in servingSizeOptions {
            options.append(ServingSizeOptionData(value: option.key, multiplier: option.value))
        }
        try container.encode(options, forKey: .servingSizeOptions)
        try container.encode(entries, forKey: .entries)
    }

    

}

struct EntryData: Codable {
    var id: UUID
    var consumeTime: Date
    var numServings: Int
    var servingSizeOption: String
    var servingSizeOptionMultiplier: Double
    var food: UUID
}

@Model
class Entry: Codable {
    
    enum CodingKeys: CodingKey {
        case id, consumeTime, numServing, servingSizeOption, servingSizeOptionMultiplier
    }
    
    
    @Attribute(.unique) var id: UUID
    var consumeTime: Date
    var numServing: Int
    var servingSizeOption: String
    var servingSizeOptionMultiplier: Double
    var food: Food?
    
    init(id: UUID = UUID(), consumeTime: Date = Date(), numServing: Int = 1, servingSizeOption: String = "100g", servingSizeOptionMultiplier: Double = 1.0) {
        self.id = id
        self.consumeTime = consumeTime
        self.numServing = numServing
        self.servingSizeOption = servingSizeOption
        self.servingSizeOptionMultiplier = servingSizeOptionMultiplier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        consumeTime = try container.decode(Date.self, forKey: .consumeTime)
        numServing = try container.decode(Int.self, forKey: .numServing)
        servingSizeOption = try container.decode(String.self, forKey: .servingSizeOption)
        servingSizeOptionMultiplier = try container.decode(Double.self, forKey: .servingSizeOptionMultiplier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(consumeTime, forKey: .consumeTime)
        try container.encode(numServing, forKey: .numServing)
        try container.encode(servingSizeOption, forKey: .servingSizeOption)
        try container.encode(servingSizeOptionMultiplier, forKey: .servingSizeOptionMultiplier)
    }
    
    
    
}


extension Entry {
    
    static func breakfastFilter(date: Date) -> Predicate<Entry> {

        let calendar = Calendar.current
        let fallBackPredicate = #Predicate<Entry> { _ in
            return false
        }

        // Calculate the date
        guard let date = calendar.date(byAdding: .day, value: 0, to: date) else {
            return fallBackPredicate
        }

        // Define the start and end times for the range (7 AM to 10 AM)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 7 // 7 AM
        components.minute = 0
        guard let startDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        components.hour = 10 // 10 AM
        components.minute = 0
        guard let endDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        // Check if the current time is between 7 AM and 10 AM of yesterday

        return #Predicate<Entry> { entry in
            return entry.consumeTime >= startDate && entry.consumeTime <= endDate
        }
    }
    static func dinnerFilter(date: Date) -> Predicate<Entry> {
        
        let calendar = Calendar.current
        let fallBackPredicate = #Predicate<Entry> { _ in
            return false
        }

        // Calculate the date
        guard let date = calendar.date(byAdding: .day, value: 0, to: date) else {
            return fallBackPredicate
        }

        // Define the start and end times for the range (7 AM to 10 AM)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 16 // 7 AM
        components.minute = 0
        guard let startDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        components.hour = 23 // 10 AM
        components.minute = 59
        guard let endDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        // Check if the current time is between 7 AM and 10 AM of yesterday

        return #Predicate<Entry> { entry in
            return entry.consumeTime >= startDate && entry.consumeTime <= endDate
        }
    }
    
    static func midnightFilter(date: Date) -> Predicate<Entry> {
        
        let calendar = Calendar.current
        let fallBackPredicate = #Predicate<Entry> { _ in
            return false
        }

        // Calculate the date
        guard let date = calendar.date(byAdding: .day, value: 0, to: date) else {
            return fallBackPredicate
        }

        // Define the start and end times for the range (7 AM to 10 AM)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 0 // 7 AM
        components.minute = 0
        guard let startDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        components.hour = 7 // 10 AM
        components.minute = 0
        guard let endDate = calendar.date(from: components) else {
            return fallBackPredicate
        }

        // Check if the current time is between 7 AM and 10 AM of yesterday

        return #Predicate<Entry> { entry in
            return entry.consumeTime >= startDate && entry.consumeTime <= endDate
        }
    }

}

extension Formatter {
   static var customISO8601DateFormatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
   }()
}

extension JSONDecoder.DateDecodingStrategy {
   static var iso8601WithFractionalSeconds = custom { decoder in
      let dateStr = try decoder.singleValueContainer().decode(String.self)
      let customIsoFormatter = Formatter.customISO8601DateFormatter
      if let date = customIsoFormatter.date(from: dateStr) {
         return date
      }
      throw DecodingError.dataCorrupted(
               DecodingError.Context(codingPath: decoder.codingPath,
                                     debugDescription: "Invalid date"))
   }
}
