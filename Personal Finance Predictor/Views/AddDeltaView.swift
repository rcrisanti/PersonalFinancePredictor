//
//  AddDeltaView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/24/21.
//

import SwiftUI

struct AddDeltaView: View {
    @State private var delta: Delta
    
    init(predictionId: UUID) {
        _delta = State(wrappedValue: Delta(forPredictionWithId: predictionId))
    }
    
    var body: some View {
        NavigationView {
            DeltaView(delta: $delta, toolbarType: .sheet, saveOnScenePhase: false)
        }
    }
}

struct AddDeltaView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeltaView(predictionId: UUID())
    }
}
