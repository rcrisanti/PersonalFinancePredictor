//
//  String+decimal.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self {
        filter(\.isWholeNumber)
    }
}

extension String {
    var double: Double {
        Double(digits) ?? 0
    }
}
