//
//  Prediction.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/18/21.
//

import Foundation

struct Prediction: Identifiable {
    let id: UUID
    var name: String
    var startBalance: Double
    var startDate: Date
    var deltas: [Delta]
    var details: String
}

extension Prediction {
    init() {
        id = UUID()
        name = ""
        startBalance = 0
        startDate = Date()
        deltas = []
        details = ""
    }
}

extension Prediction {
    init(_ prediction: PredictionCD) {
        id = prediction.id ?? UUID()
        name = prediction.name ?? ""
        startBalance = prediction.startBalance
        startDate = prediction.startDate ?? Date()
        
        let deltasCD: [DeltaCD] = prediction.deltas?.allObjects as! [DeltaCD]
        deltas = deltasCD.map { Delta($0) }
        
        details = prediction.details ?? ""
    }
}
