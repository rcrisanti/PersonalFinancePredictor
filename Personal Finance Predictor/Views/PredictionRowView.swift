//
//  PredictionRowView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/23/21.
//

import SwiftUI

struct PredictionRowView: View {
    var prediction: Prediction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(prediction.name)
                    .font(.title2)
                Spacer()
                NumDeltasIndicatorView(prediction: prediction, filter: .earnings)
                NumDeltasIndicatorView(prediction: prediction, filter: .fees)
            }
            
            HStack {
                Text("Start: \(prediction.startBalance, specifier: "$%.2f")")
                Spacer()
                Text("\(dateFormatter.string(from: prediction.startDate))")
            }
        }
        .lineLimit(1)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct PredictionRowView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionRowView(prediction: Prediction(id: UUID(), name: "My Prediction", startBalance: 1235.12, startDate: Date(), deltas: [Delta(), Delta()], details: "Here is a longer description that can\npotentially span \n many lines"))
    }
}
