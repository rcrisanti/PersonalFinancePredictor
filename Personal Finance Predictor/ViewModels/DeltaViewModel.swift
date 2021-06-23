//
//  DeltaViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/22/21.
//

import Foundation
import os.log

class DeltaViewModel: ObservableObject {
    @Published var delta: Delta
    
    var sortedDates: [Date] {
        get {
            delta.dates.sorted()
        } set {
            delta.dates = newValue
        }
    }
    
    var isDisabled: Bool {
        delta.name.isEmpty
    }
    
    init(_ delta: Delta? = nil) {
        if let delta = delta {
            self.delta = delta
        } else {
            self.delta = Delta()
        }
    }
    
    init(newFor prediction: Prediction) {
        delta = Delta(for: prediction)
    }
    
    func setUncertainty(pos: Double, neg: Double) {
        delta.positiveUncertainty = pos
        delta.negativeUncertainty = neg
    }
    
    func setUncertainty(_ to: Double) {
        setUncertainty(pos: to, neg: to)
    }
    
    func deleteSortedDates(at offsets: IndexSet) {
        for index in offsets {
            let dateToDelete = sortedDates[index]
            if let index = delta.dates.firstIndex(of: dateToDelete) {
                delta.dates.remove(at: index)
            }
        }
    }
    
    // MARK: Save & cancel
    func save() {
//        if let deltaCD = PredictionStorage.shared.getDelta(withId: delta.id) {
//            deltaCD.update(from: delta)
//        } else {
//            _ = DeltaCD.from(delta)
//        }
        Self.logger.info("Saving delta")
        _ = DeltaCD.from(delta)
        PersistenceController.shared.save()
    }
    
    func cancel() {
        PersistenceController.shared.viewContext.rollback()
        PersistenceController.shared.save()
    }
    
//    func dateRange(from start: Date, to end: Date, every interval: DateRepetition) -> [Date] {
//
//    }
    
    static let logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "DeltaViewModel")
}
