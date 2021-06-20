//
//  PredictionViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import Foundation
import Combine
import os.log

class PredictionViewModel: ObservableObject {
    @Published var prediction: Prediction {
        willSet {
            deltas = newValue.deltas
        }
    }
    @Published var deltas: [Delta]
    @Published var predictionCD: PredictionCD
    
    init(_ prediction: Prediction) {
        self.prediction = prediction
        self.deltas = prediction.deltas
        
        do {
            self.predictionCD = try PredictionStorage.shared.getPrediction(withId: prediction.id)
        } catch let error {
            // MARK: THIS CAUSES ERRORS - HOW TO DEAL WITH NEW PREDICTION??
            
            Self.logger.error("\(error.localizedDescription)")
            self.predictionCD = PredictionCD(context: PersistenceController.shared.viewContext)
            predictionCD.id = prediction.id
//            PersistenceController.shared.save()
        }
        
    }
    
    func save() {
        predictionCD.id = prediction.id
        predictionCD.name = prediction.name
        predictionCD.details = prediction.details
        predictionCD.startBalance = prediction.startBalance
        predictionCD.startDate = prediction.startDate
//            predictionCD.addToDeltas(newValue.deltas.map {
//                let deltaCD = DeltaCD(context: PersistenceController.shared.viewContext)
//                deltaCD.id = $0.id
//                deltaCD.name = $0.name
//                deltaCD.details = $0.details
//                deltaCD.positiveUncertainty = $0.positiveUncertainty
//                deltaCD.negativeUncertainty = $0.negativeUncertainty
//                deltaCD.dates = $0.dates
//
//                return deltaCD
//            })
        
        PersistenceController.shared.save()
    }
    
    func cancel() {
        PersistenceController.shared.viewContext.rollback()
        PersistenceController.shared.save()
    }
    
    func addDelta() {
        let delta = DeltaCD(context: PersistenceController.shared.viewContext)
        delta.id = UUID()
        delta.name = "Test Delta"
        delta.value = 123.4
        delta.positiveUncertainty = 20
        delta.negativeUncertainty = 20
        delta.details = "Here is a longer description"
        delta.prediction = predictionCD
        
        PersistenceController.shared.save()
    }
    
    func deleteDeltas(atOffsets: IndexSet) {
        for index in atOffsets {
            let delta = deltas[index]            
            let deltasCD: [DeltaCD] = predictionCD.deltas?.allObjects as! [DeltaCD]
            
            if let toDelete = deltasCD.first(where: { $0.id == delta.id } ) {
                PersistenceController.shared.viewContext.delete(toDelete)
                PersistenceController.shared.save()
            } else {
                Self.logger.error("Cannot find delta with ID \(delta.id)")
            }
        }
    }
    
    static let logger = Logger(subsystem: "com.rcisanti.Personal-Finance-Predictor", category: "PredictionViewModel")
}
