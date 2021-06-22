//
//  DateRepetition.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/22/21.
//

import Foundation

enum DateRepetition: String, CaseIterable, Identifiable {
    case oneTime = "One Time Occurance"
    case yearly = "Yearly"
    case monthy = "Monthly"
    case weekly = "Weekly"
    case daily = "Daily"
    case custom = "Custom"
    
    var id: String {
        self.rawValue
    }
}
