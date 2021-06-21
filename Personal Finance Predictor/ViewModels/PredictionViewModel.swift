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
    @Published var prediction: Prediction
    var isDisabled: Bool {
        prediction.name.isEmpty
    }
    
    init(_ prediction: Prediction? = nil) {
        if let prediction = prediction {
            self.prediction = prediction
        } else {
            self.prediction = Prediction()
        }
    }
    
    // MARK: Save & Cancel
    func save() {
        _ = PredictionCD.fromPrediction(prediction)
        PersistenceController.shared.save()
    }
    
    func cancel() {
        PersistenceController.shared.viewContext.rollback()
        PersistenceController.shared.save()
    }
    
    // MARK: Add & Delete
    func addDelta() {
        let delta = Delta(
            id: UUID(),
            name: "Test Delta",
            value: 1234,
            details: "A little bit extra about it",
            dates: [],
            positiveUncertainty: 20,
            negativeUncertainty: 20
        )
        prediction.deltas.append(delta)
    }
    
    enum DeleteFrom {
        case all, negative, nonnegative
    }
    
    func deleteDeltas(atOffsets: IndexSet, deleteFrom: DeleteFrom = .all) {
        for index in atOffsets {
            switch deleteFrom {
            case .all:
                prediction.deltas.remove(at: index)
            case.negative:
                let toRemove = prediction.deltas.filter( { $0.value >= 0} )[index]
                if let foundIndex = prediction.deltas.firstIndex(of: toRemove) {
                    prediction.deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            case.nonnegative:
                let toRemove = prediction.deltas.filter( { $0.value > 0} )[index]
                if let foundIndex = prediction.deltas.firstIndex(of: toRemove) {
                    prediction.deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            }
        }
    }
    
    static let logger = Logger(subsystem: "com.rcisanti.Personal-Finance-Predictor", category: "PredictionViewModel")
}
