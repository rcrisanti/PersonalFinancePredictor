//
//  PredictionEditView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct PredictionEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PredictionViewModel
    @State private var startBalance: String = ""
    
    init(viewModel: PredictionViewModel = PredictionViewModel(Prediction())) {
        self.viewModel = viewModel
    }
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.prediction.name)
            
            DatePicker("Start Date", selection: $viewModel.prediction.startDate, displayedComponents: .date)
            
            TextField("Start Balance", value: $startBalance, formatter: formatter, onEditingChanged: { _ in }, onCommit: {
                viewModel.prediction.startBalance = Double(startBalance) ?? 0
            })
            .keyboardType(.decimalPad)
            
            Section(header: Text("Description")) {
                TextEditor(text: $viewModel.prediction.details)
            }
            
            Section(header: HStack {
                Text("Earnings")
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                }
            }) {
                List {
                    ForEach(viewModel.deltas.filter( { $0.value >= 0} )) { earning in
                        DeltaRowView(delta: earning)
                    }
                }
            }
            
            Section(header: HStack {
                Text("Fees")
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                }
                
            }) {
                List {
                    ForEach(viewModel.deltas.filter( { $0.value < 0} )) { fee in
                        DeltaRowView(delta: fee)
                    }
                }
            }
        }
        .navigationTitle("Edit Prediction")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.cancel()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct PredictionEditView_Previews: PreviewProvider {
    static let prediction = Prediction(
        id: UUID(),
        name: "",
        startBalance: 0,
        startDate: Date(),
        deltas: [],
        details: ""
    )
    
    static var previews: some View {
        NavigationView {
            PredictionEditView(viewModel: PredictionViewModel(prediction))
        }
    }
}
