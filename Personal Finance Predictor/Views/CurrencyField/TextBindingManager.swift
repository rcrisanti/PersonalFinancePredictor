//
//  TextBindingManager.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import Foundation

class TextBindingManager: ObservableObject {
    @Published var text: String = ""
    var amount: Double = .zero
    
    init(amount: Double) {
        self.amount = amount
        self.text = Formatter.currency.string(for: amount) ?? "$0.00"
    }
}
