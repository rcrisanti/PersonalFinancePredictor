//
//  Decimal+currency.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import Foundation

extension Double {
    var currency: String {
        Formatter.currency.string(for: self) ?? ""
    }
}
