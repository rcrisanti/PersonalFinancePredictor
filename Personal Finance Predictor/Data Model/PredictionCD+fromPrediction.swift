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
        addToDeltas(NSSet(array: prediction.deltas.map({ delta in
            if let deltaCD = PredictionStorage.shared.getDelta(withId: delta.id) {
                deltaCD.update(from: delta)
                PersistenceController.shared.save()
                return deltaCD
            } else {
                let deltaCD = DeltaCD(delta: delta)
                PersistenceController.shared.save()
                return deltaCD
            }
        })))
    }
}
