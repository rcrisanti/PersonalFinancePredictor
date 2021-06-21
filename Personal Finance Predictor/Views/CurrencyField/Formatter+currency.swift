//
//  Formatter+currency.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import Foundation

extension Formatter {
    static let currency: NumberFormatter = .init(numberStyle: .currency)
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
