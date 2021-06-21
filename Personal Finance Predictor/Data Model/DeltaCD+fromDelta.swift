//
//  DeltaCD+fromDelta.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DeltaCD {
    static func fromDelta(_ delta: Delta, for predictionCD: PredictionCD) -> DeltaCD {
        let deltaCD = DeltaCD(context: PersistenceController.shared.viewContext)
        deltaCD.id = delta.id
        deltaCD.name = delta.name
        deltaCD.value = delta.value
        deltaCD.positiveUncertainty = delta.positiveUncertainty
        deltaCD.negativeUncertainty = delta.negativeUncertainty
        deltaCD.details = delta.details
        deltaCD.prediction = predictionCD
        deltaCD.addToDates(NSSet(array: delta.dates.map { DateCD.fromDate($0, for: deltaCD) }))
        return deltaCD
    }
}
