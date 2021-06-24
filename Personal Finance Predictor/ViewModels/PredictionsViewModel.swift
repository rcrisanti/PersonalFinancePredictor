//
//  PredictionsViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/19/21.
//

import Foundation
import SwiftUI
import os.log
import CoreData
import Combine

class PredictionsViewModel: ObservableObject {
    @Published var predictionsCD: [PredictionCD] = [] {
        willSet {
            Self.logger.info("willSet predictionsCD to \(newValue)")
            predictions = newValue.map { Prediction($0) }
//            predictionVMs = predictions.map { PredictionViewModel(prediction: $0) }
        }
    }
    @Published var predictions: [Prediction] = [] {
        willSet {
            Self.logger.info("willSet predictions to \(newValue)")
        }
    }
//    @Published var predictionVMs: [PredictionViewModel] = []
    
    private var cancellable: AnyCancellable?
    
    init(predictionPublisher: AnyPublisher<[PredictionCD], Never> = PredictionStorage.shared.predictions.eraseToAnyPublisher()) {
        cancellable = predictionPublisher.sink { predictions in
            self.predictionsCD = predictions
        }
    }

    func deletePredictions(atOffsets: IndexSet) {
        for index in atOffsets {
            let toDelete = predictionsCD[index]
            PredictionStorage.shared.delete(toDelete)
        }
        PersistenceController.shared.save()
    }
    
    static var logger = Logger(subsystem: "com.rcisanti.Personal-Finance-Predictor", category: "PredictionsViewModel")
}
