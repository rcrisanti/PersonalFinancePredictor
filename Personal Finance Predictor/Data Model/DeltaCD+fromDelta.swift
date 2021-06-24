//
//  DeltaCD+fromDelta.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DeltaCD {
    convenience init(delta: Delta) {
        self.init(context: PersistenceController.shared.viewContext)
        update(from: delta)
    }
    
    func update(from delta: Delta) {
        id = delta.id
        name = delta.name
        value = delta.value
        positiveUncertainty = delta.positiveUncertainty
        negativeUncertainty = delta.negativeUncertainty
        details = delta.details
        dateRepetition = delta.dateRepetition.rawValue
        PersistenceController.shared.save()
        
        removeFromDates(dates ?? NSSet())
        addToDates(NSSet(array: delta.dates.map { DateCD.from($0, for: self) }))
        PersistenceController.shared.save()
        
        if let predictionId = delta.predictionId {
            if let predictionCD = PredictionStorage.shared.getPrediction(withId: predictionId) {
                prediction = predictionCD
            } else {
                let predictionCD = PredictionCD(context: PersistenceController.shared.viewContext)
                predictionCD.id = predictionId
                predictionCD.addToDeltas(self)
                prediction = predictionCD
            }
        } else {
            let predictionCD = PredictionCD(context: PersistenceController.shared.viewContext)
            predictionCD.addToDeltas(self)
            prediction = predictionCD
        }
        PersistenceController.shared.save()
    }
}
