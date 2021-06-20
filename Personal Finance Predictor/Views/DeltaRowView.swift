//
//  DeltaRowView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct DeltaRowView: View {
    var delta: Delta
    
    var specifier: String {
        if delta.value >= 0 {
            return "$%.2f"
        } else {
            return "($%.2f)"
        }
    }
    
    var body: some View {
        HStack {
            Text(delta.name)
            Spacer()
            Text("\(abs(delta.value), specifier: specifier)")
        }
    }
}

struct DeltaRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaRowView(delta: Delta(id: UUID(), name: "Paycheck", value: -850, details: "", dates: [], positiveUncertainty: 0, negativeUncertainty: 0))
    }
}
