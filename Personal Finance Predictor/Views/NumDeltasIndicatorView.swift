//
//  NumDeltasIndicatorView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/23/21.
//

import SwiftUI

struct NumDeltasIndicatorView: View {
    var prediction: Prediction
    var filter: DeltaFilter
    
    var number: Int {
        switch filter {
        case .all:
            return prediction.deltas.count
        case .earnings:
            return prediction.deltas.filter { $0.value >= 0 }.count
        case .fees:
            return prediction.deltas.filter { $0.value < 0 }.count
        }
    }
    
    var color: Color {
        switch filter {
        case .all:
            return .yellow
        case .earnings:
            return .green
        case .fees:
            return .red
        }
    }
    
    var image: Image {
        switch filter {
        case .all:
            return Image(systemName: "chevron.up.chevron.down")
        case .earnings:
            return Image(systemName: "chevron.up")
        case .fees:
            return Image(systemName: "chevron.down")
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(number)")
            image
        }
        .padding(10)
        .background(Circle().foregroundColor(color).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/))
    }
}

struct NumDeltasIndicatorView_Previews: PreviewProvider {
    static let prediction = Prediction(
        id: UUID(),
        name: "My Prediction",
        startBalance: 1235.12,
        startDate: Date(),
        deltas: [Delta(), Delta()],
        details: "Here is a longer description that can\npotentially span \n many lines"
    )
    
    static var previews: some View {
        NumDeltasIndicatorView(prediction: prediction, filter: .all)
    }
}
