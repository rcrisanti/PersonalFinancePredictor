//
//  PredictionCD+fromPrediction.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension PredictionCD {
    static func fromPrediction(_ prediction: Prediction) -> PredictionCD {
        let predictionCD = PredictionCD(context: PersistenceController.shared.viewContext)
        predictionCD.id = prediction.id
        predictionCD.name = prediction.name
        predictionCD.startDate = prediction.startDate
        predictionCD.startBalance = prediction.startBalance
        predictionCD.details = prediction.details
        predictionCD.addToDeltas(NSSet(array: prediction.deltas.map { DeltaCD.fromDelta($0, for: predictionCD) } ))
        return predictionCD
    }
}
