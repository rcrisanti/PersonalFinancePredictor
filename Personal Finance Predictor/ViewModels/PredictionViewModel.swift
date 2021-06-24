//
//  PredictionViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import Foundation
import Combine
import os.log

enum DeltaFilter {
    case earnings, fees, all
}

class PredictionViewModel: ObservableObject {
    @Published var prediction: Prediction {
        willSet {
            Self.logger.info("willSet Prediction to \(newValue)")
//            deltaVMs = newValue.deltas.map { DeltaViewModel($0) }
        }
    }
//    @Published var deltaVMs: [DeltaViewModel] = [] {
//        willSet {
//            Self.logger.info("willSet deltaVMs to \(newValue)")
//        }
//    }
    
    var cancellable: AnyCancellable?
            
    init(prediction: Prediction? = nil) {
        if let prediction = prediction {
            self.prediction = prediction
        } else {
            self.prediction = Prediction()
        }
        
//        cancellable = $deltaVMs.sink { _ in
//            self.objectWillChange.send()
//        }
    }
    
    var isDisabled: Bool {
        prediction.name.isEmpty
    }
    
    var earnings: [Delta] {
        prediction.deltas.filter { $0.value >= 0 }
    }
    
    var fees: [Delta] {
        prediction.deltas.filter { $0.value < 0 }
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
    func deleteDeltas(atOffsets: IndexSet, deleteFrom: DeltaFilter = .all) {
        for index in atOffsets {
            switch deleteFrom {
            case .all:
                prediction.deltas.remove(at: index)
            case .fees:
                let toRemove = fees[index]
                if let foundIndex = prediction.deltas.firstIndex(of: toRemove) {
                    prediction.deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            case .earnings:
                let toRemove = earnings[index]
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
