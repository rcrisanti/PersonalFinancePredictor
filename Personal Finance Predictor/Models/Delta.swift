//
//  Delta.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/18/21.
//

import Foundation

struct Delta: Identifiable, Hashable {
    static func == (lhs: Delta, rhs: Delta) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var value: Double
    var details: String
    var dates: [Date]
    var positiveUncertainty: Double
    var negativeUncertainty: Double
    var dateRepetition: DateRepetition
    var predictionId: UUID?
}

extension Delta {
    init(for prediction: Prediction? = nil) {
        id = UUID()
        name = ""
        value = 0
        details = ""
        dates = []
        positiveUncertainty = 0
        negativeUncertainty = 0
        dateRepetition = .custom
        predictionId = prediction?.id
    }
}

extension Delta {
    init(_ delta: DeltaCD) {
        id = delta.id ?? UUID()
        name = delta.name ?? ""
        value = delta.value
        details = delta.details ?? ""
        
        let datesCD: [DateCD] = delta.dates?.allObjects as! [DateCD]
        dates = datesCD.map { $0.date ?? Date() }
        
        positiveUncertainty = delta.positiveUncertainty
        negativeUncertainty = delta.negativeUncertainty
        
//        dateRepetition = DateRepetition(rawValue: delta.dateRepetition ?? "Custom") ?? .custom
        dateRepetition = .custom
        predictionId = delta.prediction?.id
    }
}
