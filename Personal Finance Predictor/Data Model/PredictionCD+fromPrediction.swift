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
        self.update(from: prediction)
    }
    
    func update(from prediction: Prediction) {
        id = prediction.id
        name = prediction.name
        startDate = prediction.startDate
        startBalance = prediction.startBalance
        details = prediction.details
        removeFromDeltas(deltas ?? NSSet())
//        addToDeltas(NSSet(array: prediction.deltas.map { DeltaCD(delta: $0) } ))
        addToDeltas(NSSet(array: prediction.deltas.map { DeltaCD.from($0) } ))
    }
}
