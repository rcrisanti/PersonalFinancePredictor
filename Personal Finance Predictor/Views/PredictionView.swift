//
//  PredictionView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct PredictionView: View {
    @ObservedObject var viewModel: PredictionViewModel
    
    var body: some View {
        Form {
            Section(header: Text("About")) {
                Text("\(formatDate(viewModel.prediction.startDate)): \(viewModel.prediction.startBalance, specifier: "$%.2f")")
                
                Text(viewModel.prediction.details)
            }
            
            Section(header: HStack {
                Text("Deltas")
                Spacer()
                Button(action: {
                    viewModel.addDelta()
                }) {
                    Image(systemName: "plus")
                }
            }) {
                List {
                    ForEach(viewModel.deltas) { delta in
                        DeltaRowView(delta: delta)
                    }
                    .onDelete(perform: viewModel.deleteDeltas)
                }
            }
        }
        .navigationBarTitle(viewModel.prediction.name)
    }
}

func formatDate(_ date: Date, timeStyle: DateFormatter.Style = .none, dateStyle: DateFormatter.Style = .short, dateFormat: String? = nil) -> String {
    let formatter = DateFormatter()
    if let dateFormat = dateFormat {
        formatter.dateFormat = dateFormat
    } else {
        formatter.timeStyle = timeStyle
        formatter.dateStyle = dateStyle
    }
    return formatter.string(from: date)
}

struct PredictionView_Previews: PreviewProvider {
    static let prediction = Prediction(
        id: UUID(),
        name: "Test Prediction",
        startBalance: 1234.2,
        startDate: Date(),
        deltas: [
            Delta(id: UUID(), name: "Paycheck", value: 854.12, details: "Make that MONEYYYY", dates: [Date(), Date(timeInterval: 100000, since: Date())], positiveUncertainty: 10, negativeUncertainty: 10)
        ],
        details: "Some more, detailed, information"
    )
    
    static var previews: some View {
        NavigationView {
            PredictionView(viewModel: PredictionViewModel(prediction))
        }
    }
}
