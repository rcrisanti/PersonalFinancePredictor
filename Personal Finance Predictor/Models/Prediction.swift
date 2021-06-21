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
//    var deltas: Set<Delta>
    var deltas: [Delta]
    var details: String
}

extension Prediction {
    init() {
        self.id = UUID()
        self.name = ""
        self.startBalance = 0
        self.startDate = Date()
        self.deltas = []
        self.details = ""
    }
}

extension Prediction {
    init(_ prediction: PredictionCD) {
        self.id = prediction.id ?? UUID()
        self.name = prediction.name ?? ""
        self.startBalance = prediction.startBalance
        self.startDate = prediction.startDate ?? Date()
        
        let deltasCD: [DeltaCD] = prediction.deltas?.allObjects as! [DeltaCD]
//        self.deltas = Set(deltasCD.map { Delta($0) })
        self.deltas = deltasCD.map { Delta($0) }
        
        self.details = prediction.details ?? ""
    }
}
