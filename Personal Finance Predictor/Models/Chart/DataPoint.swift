//
//  Struct.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/27/21.
//

import Foundation

struct DataPoint {
    var date: Date
    var value: Double
    var minRange: Double
    var maxRange: Double
    
    init(date: Date, value: Double, minRange: Double, maxRange: Double) {
        self.date = date
        self.value = value
        self.minRange = minRange
        self.maxRange = maxRange
    }
}
