//
//  DataController_RestAPI.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/1/24.
//

import Foundation

struct TokenData: Codable {
    let token: String
}

extension DataController {
    
    
    func login(username: String, password: String) async {
        
        // Perform authentication with your server.
        // Replace this with your actual login API call.
        // For demonstration purposes, use a mock API.
        guard let url = URL(string: "http://127.0.0.1:8000/api/api-token-auth/") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "username": "\(username)",
            "password": "\(password)"
        }
        """.data(using: .utf8)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            let decodedData = try JSONDecoder().decode(TokenData.self, from: data)
            let key = "userToken"
            let saveSuccess = KeychainService.saveTokenToKeychain(token: decodedData.token, forKey: key)
            if saveSuccess {
                isLoggedIn = true
            } else {
                print("Failed to save token to Keychain")
            }
        } catch {
            self.error = error
        }
        
    }
    
    func logout() {
        KeychainService.deleteTokenFromKeychain(forKey: keychainKey)
        isLoggedIn = false
    }
    
    func checkToken() {
        // Check if a token exists in Keychain
        if KeychainService.loadTokenFromKeychain(forKey: keychainKey) != nil {
            isLoggedIn = true
        }
    }
    
    func fetchAllFood() async -> [Food] {
        guard isLoggedIn else {return []}
        guard let token = KeychainService.loadTokenFromKeychain(forKey: "userToken") else {return []}
        guard let url = URL(string: "http://127.0.0.1:8000/api/foods/") else {return []}
        let decodedData: [Food]
        
        var request = URLRequest(url: url)
        
        
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
            decodedData = try decoder.decode([Food].self, from: data)
            return decodedData
        } catch {
            print(error.localizedDescription)
            self.error = error
            return []
        }
        
    }
    
    func addFood(name: String, calories: Int, proteins: Int, fat: Int, carbs: Int, numServing: Int, servingSizeOption: String, servingSizeOptionMultiplier: Double, options: [ServingSizeOption] ) async -> Food? {
        guard isLoggedIn else {return nil}
        guard let token = KeychainService.loadTokenFromKeychain(forKey: "userToken") else {return nil}
        guard let url = URL(string: "http://127.0.0.1:8000/api/foods/") else {return nil}

        
        var optionsJSON = ""
        for i in 0...options.count-1 {
            optionsJSON = optionsJSON + """
            {
                "value": "\(options[i].value)",
                "multiplier": \(options[i].multiplier)
            }
            """
            if i != options.count-1 {
                optionsJSON = optionsJSON + ","
            }
        }
        
        let jsonString = """
        {
            "servingSizeOptions": [
                \(optionsJSON)
            ],
            "entries": [
                {
                    "numServing": "\(numServing)",
                    "servingSizeOption": "\(servingSizeOption)",
                    "servingSizeOptionMultiplier": "\(servingSizeOptionMultiplier)"
                }
            ],
            "name": "\(name)",
            "calories": \(calories),
            "proteins": \(proteins),
            "carbohydrates": \(carbs),
            "fat": \(fat)

        }
        """
        print(jsonString)
        
        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
            let decodedData = try decoder.decode(Food.self, from: data)
            return decodedData
        } catch {
            self.error = error
            return nil
        }
        
    }
    
    func updateEntry(id: UUID, consumeTime: Date, numServing: Int, servingSizeOption: String, servingSizeOptionMultiplier: Double) async  -> Entry? {
        guard isLoggedIn else {return nil}
        guard let token = KeychainService.loadTokenFromKeychain(forKey: "userToken") else {return nil}
        guard let url = URL(string: "http://127.0.0.1:8000/api/entry/\(id.uuidString)") else {return nil}
        
        let jsonString = """
        {
            "consumeTime": "\(consumeTime.ISO8601Format(.iso8601(timeZone: .gmt, includingFractionalSeconds: true)))Z",
            "numServing": "\(numServing)",
            "servingSizeOption": "\(servingSizeOption)",
            "servingSizeOptionMultiplier": "\(servingSizeOptionMultiplier)"
        }
        """
        
        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = jsonString.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
            let decodedData = try decoder.decode(Entry.self, from: data)
            return decodedData
        } catch {
            self.error = error
            return nil
        }
    }
    
    func deleteEntry(entry: Entry) async -> Bool {
        guard isLoggedIn else {return false}
        guard let token = KeychainService.loadTokenFromKeychain(forKey: "userToken") else {return false}
        guard let url = URL(string: "http://127.0.0.1:8000/api/entry/\(entry.id.uuidString)") else {return false}
        
        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(String.self, from: data)
            return decodedData == "Item deleted successfully"
        } catch {
            self.error = error
            return false
        }
    }
    
    
    func updateFood(id: UUID, name: String, calories: Int, proteins: Int, fat: Int, carbs: Int, options: [ServingSizeOption]) async -> Food? {
        guard isLoggedIn else {return nil}
        guard let token = KeychainService.loadTokenFromKeychain(forKey: "userToken") else {return nil}
        guard let url = URL(string: "http://127.0.0.1:8000/api/foods/\(id.uuidString)") else {return nil}

        
        var optionsJSON = ""
        for i in 0...options.count-1 {
            optionsJSON = optionsJSON + """
            {
                "value": "\(options[i].value)",
                "multiplier": \(options[i].multiplier)
            }
            """
            if i != options.count-1 {
                optionsJSON = optionsJSON + ","
            }
        }
        
        let jsonString = """
        {
            "servingSizeOptions": [
                \(optionsJSON)
            ],
            "name": "\(name)",
            "calories": \(calories),
            "proteins": \(proteins),
            "carbohydrates": \(carbs),
            "fat": \(fat)

        }
        """
        print(jsonString)
        
        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = jsonString.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
            let decodedData = try decoder.decode(Food.self, from: data)
            return decodedData
        } catch {
            self.error = error
            return nil
        }
    }
    
}
