//
//  PredictionViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import Foundation
import SwiftUI
import Combine
import os.log

enum DeltaFilter {
    case earnings, fees, all
}

class PredictionViewModel: ObservableObject {
    @Published private var prediction: Prediction {
        willSet {
            Self.logger.info("willSet Prediction to \(newValue)")
        }
    }
    
    func getIndexOfDelta(withId id: UUID) -> Int {
        guard let index = deltas.firstIndex(where: { $0.id == id }) else {
            Self.logger.critical("Could not find index of Delta with ID \(id.uuidString) - returning an index of 0")
            return 0
        }
        return index
    }

    
    // MARK: - Basic properties & init
    var id: UUID {
        get { prediction.id }
    }
    
    var name: String {
        get { prediction.name }
        set { prediction.name = newValue }
    }
    
    var startBalance: Double {
        get { prediction.startBalance }
        set { prediction.startBalance = newValue }
    }
    
    var startDate: Date {
        get { prediction.startDate }
        set { prediction.startDate = newValue }
    }
    
    var deltas: [Delta] {
        get { prediction.deltas }
        set { prediction.deltas = newValue }
    }
    
    var details: String {
        get { prediction.details }
        set { prediction.details = newValue }
    }
                
    init(prediction: Prediction = Prediction()) {
        self.prediction = prediction
    }
    
    // MARK: - Helper computed properties
    var isDisabled: Bool {
        prediction.name.isEmpty
    }
    
    var earnings: [Delta] {
        prediction.deltas.filter { $0.value >= 0 }
    }

    var fees: [Delta] {
        prediction.deltas.filter { $0.value < 0 }
    }
    
    // MARK: - Save, Delete, Add, Cancel
    func save() {
        if let predictionCD = PredictionStorage.shared.getPrediction(withId: prediction.id) {
            predictionCD.update(from: prediction)
        } else {
            _ = PredictionCD(prediction: prediction)
        }
        PersistenceController.shared.save()
    }
    
    func deleteDeltas(atOffsets: IndexSet, deleteFrom: DeltaFilter = .all) {
        for index in atOffsets {
            switch deleteFrom {
            case .all:
                deltas.remove(at: index)
            case .fees:
                let toRemove = fees[index]
                if let foundIndex = prediction.deltas.firstIndex(where: { $0.id == toRemove.id }) {
                    deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            case .earnings:
                let toRemove = earnings[index]
                if let foundIndex = prediction.deltas.firstIndex(where: { $0.id == toRemove.id }) {
                    deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            }
        }
    }
    
    // MARK: - Logger
    static let logger = Logger(subsystem: "com.rcisanti.Personal-Finance-Predictor", category: "PredictionViewModel")
}
