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
    
    let withFullToolbar: Bool
    
    init(prediction: Prediction? = nil) {
        if let prediction = prediction {
            self.prediction = prediction
            withFullToolbar = false
        } else {
            self.prediction = Prediction()
            withFullToolbar = true
        }
    }
    
    var isDisabled: Bool {
        prediction.name.isEmpty
    }
    
    // MARK: Save
    func save() {
        if let predictionCD = PredictionStorage.shared.getPrediction(withId: prediction.id) {
            predictionCD.update(from: prediction)
        } else {
            _ = PredictionCD(prediction: prediction)
        }
        PersistenceController.shared.save()
    }
    
    // MARK: Delete
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
