//
//  DeltaCD+fromDelta.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DeltaCD {
    convenience init(delta: Delta, for predictionCD: PredictionCD) {
        self.init(context: PersistenceController.shared.viewContext)
        id = delta.id
        name = delta.name
        value = delta.value
        positiveUncertainty = delta.positiveUncertainty
        negativeUncertainty = delta.negativeUncertainty
        details = delta.details
        prediction = predictionCD
        addToDates(NSSet(array: delta.dates.map { DateCD(date: $0, for: self) }))
    }
}
