//
//  StringDoubleToServingSizeOption.swift
//  YummyHealthy
//
//  Created by Mark Le on 1/23/24.
//

import Foundation

extension [String: Double] {
    func toOptions() -> [ServingSizeOption] {
        var options = [ServingSizeOption]()
        for value in self.keys {
            options.append(ServingSizeOption(value: value, multiplier: self[value]!))
        }
        
        return options
    }
    
}
