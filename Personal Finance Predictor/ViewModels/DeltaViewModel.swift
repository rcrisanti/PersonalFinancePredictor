//
//  DeltaViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/24/21.
//

import SwiftUI

class DeltaViewModel: ObservableObject {
    // MARK: Delta & Properties
    @Binding private var delta: Delta
    
    @Published var name: String {
        willSet {
            delta.name = newValue
        }
    }
    
    @Published var value: Double {
        willSet {
            delta.value = newValue
        }
    }
    
    @Published var details: String {
        willSet {
            delta.details = newValue
        }
    }
    
    @Published var dates: [Date] {
        willSet {
            delta.dates = newValue
//            sortedDates = newValue.sorted()
        }
    }
    
    @Published var positiveUncertainty: Double {
        willSet {
            delta.positiveUncertainty = newValue
        }
    }
    
    @Published var negativeUncertainty: Double {
        willSet {
            delta.negativeUncertainty = newValue
        }
    }
    
    @Published var dateRepetition: DateRepetition {
        willSet {
            delta.dateRepetition = newValue
        }
    }
    
    var predictionId: UUID?
    
    init(delta: Binding<Delta>) {
        _delta = delta
        
        name = delta.wrappedValue.name
        value = delta.wrappedValue.value
        details = delta.wrappedValue.details
        dates = delta.wrappedValue.dates
        positiveUncertainty = delta.wrappedValue.positiveUncertainty
        negativeUncertainty = delta.wrappedValue.negativeUncertainty
        dateRepetition = delta.wrappedValue.dateRepetition
        
        uncertaintyIsSymmetric = positiveUncertainty == negativeUncertainty
        
        sortDates()
    }
    
    // MARK: - State properties
    @Published var uncertaintyIsSymmetric = true
    
//    @Published var sortedDates: [Date]
    
    // MARK: - Helper Functions
    func addDate() {
        dates.append(Date())
    }
    
    func sortDates(deadline: DispatchTime = .now()) {
//        dates.sort()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.dates.sort()
        }        
    }
    
    func setBothUncertainties(to value: Double) {
        positiveUncertainty = value
        negativeUncertainty = value
    }
    
    // MARK: - Save & Delete
    func save() {
        if let deltaCD = PredictionStorage.shared.getDelta(withId: delta.id) {
            deltaCD.update(from: delta)
        } else {
            _ = DeltaCD(delta: delta)
        }
        PersistenceController.shared.save()
    }
    
    func deleteDates(at offsets: IndexSet) {
        for index in offsets {
            dates.remove(at: index)
        }
    }
}
