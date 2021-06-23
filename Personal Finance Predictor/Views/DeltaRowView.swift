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
    
    var dates: String {
        let dateStrings = delta.dates.sorted().map { dateFormatter.string(from: $0) }
        return dateStrings.joined(separator: ", ")
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(delta.name)
                    .font(.headline)
                Spacer()
                Text("\(abs(delta.value), specifier: specifier)")
            }
            
            Text("\(delta.dateRepetition.rawValue.capitalized)\(delta.dates.count > 0 ? ": " : "")\(dates)")
                .font(.caption)
        }
        .lineLimit(1)
    }
}

struct DeltaRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaRowView(delta: Delta(id: UUID(), name: "Paycheck", value: -850, details: "", dates: [], positiveUncertainty: 0, negativeUncertainty: 0, dateRepetition: .custom, predictionId: UUID()))
    }
}
