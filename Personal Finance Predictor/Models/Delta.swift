//
//  Delta.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/18/21.
//

import Foundation

struct Delta: Identifiable, Hashable {
    let id: UUID
    var name: String
    var value: Double
    var details: String
    var dates: [Date]
    var positiveUncertainty: Double
    var negativeUncertainty: Double
}

extension Delta {
    init(_ delta: DeltaCD) {
        self.id = delta.id ?? UUID()
        self.name = delta.name ?? ""
        self.value = delta.value
        self.details = delta.details ?? ""
        
        let datesCD: [DateCD] = delta.dates?.allObjects as! [DateCD]
        self.dates = datesCD.map { $0.date ?? Date() }
        
        self.positiveUncertainty = delta.positiveUncertainty
        self.negativeUncertainty = delta.negativeUncertainty
    }
}
