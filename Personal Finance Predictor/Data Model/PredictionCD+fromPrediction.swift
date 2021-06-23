//
//  PredictionCD+fromPrediction.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension PredictionCD {
    convenience init(prediction: Prediction) {
        self.init(context: PersistenceController.shared.viewContext)
        id = prediction.id
        name = prediction.name
        startDate = prediction.startDate
        startBalance = prediction.startBalance
        details = prediction.details
        addToDeltas(NSSet(array: prediction.deltas.map { DeltaCD(delta: $0, for: self) } ))
    }
}
