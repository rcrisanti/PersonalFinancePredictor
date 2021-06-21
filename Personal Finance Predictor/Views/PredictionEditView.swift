//
//  PredictionEditView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct PredictionEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingNewDeltaSheet = false
    @State private var newDeltaSheetIsOpen = false
    @ObservedObject var viewModel: PredictionViewModel
    
    init(viewModel: PredictionViewModel = PredictionViewModel()) {
        self.viewModel = viewModel
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        Form {
            
            Section {
                TextField("Name", text: $viewModel.prediction.name)
                
                DatePicker("Start Date", selection: $viewModel.prediction.startDate, displayedComponents: .date)
                
                TextField(
                    "Start Balance",
                    value: $viewModel.prediction.startBalance,
                    formatter: formatter
                )
                .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Description")) {
                TextEditor(text: $viewModel.prediction.details)
            }
            
            Section(header: HStack {
                Text("Earnings")
                Spacer()
                Button(action: {
//                    viewModel.addDelta()
                    isShowingNewDeltaSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }) {
                List {
                    ForEach(viewModel.prediction.deltas.filter( { $0.value >= 0} )) { earning in
                        DeltaRowView(delta: earning)
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .nonnegative)
                    })
                }
            }
            
            Section(
                header: HStack {
                    Text("Fees")
                    Spacer()
                    Button(action: {
//                        viewModel.addDelta()
                        isShowingNewDeltaSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                },
                footer: Text("Don't worry... all of this can be changed later!")
            ) {
                List {
                    ForEach(viewModel.prediction.deltas.filter( { $0.value < 0} )) { fee in
                        DeltaRowView(delta: fee)
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .negative)
                    })
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
        .bottomSheet(isPresented: $isShowingNewDeltaSheet, isOpen: $newDeltaSheetIsOpen) {
            DeltaView()
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
