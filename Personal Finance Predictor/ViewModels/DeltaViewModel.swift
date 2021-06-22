//
//  DeltaViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/22/21.
//

import Foundation

class DeltaViewModel: ObservableObject {
    @Published var delta: Delta
    
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
    
    func setUncertainty(pos: Double, neg: Double) {
        delta.positiveUncertainty = pos
        delta.negativeUncertainty = neg
    }
    
    func setUncertainty(_ to: Double) {
        setUncertainty(pos: to, neg: to)
    }
}
