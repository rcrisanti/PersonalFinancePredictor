//
//  PredictionView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI
import os.log

struct PredictionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingNewDeltaSheet = false
    @ObservedObject var viewModel: PredictionViewModel
    
    let toolbarType: ToolbarType
    
    init(viewModel: PredictionViewModel = PredictionViewModel(), toolbarType: ToolbarType) {
        self.viewModel = viewModel
        self.toolbarType = toolbarType
    }
    
    var body: some View {
        Form {
            Section {
                introSection
            }
            
            Section(header: Text("Description")) {
                TextEditor(text: $viewModel.details)
            }
            
            Section(header: VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    isShowingNewDeltaSheet = true
                }) {
                    Label("Add Earning/Fee", systemImage: "plus")
                }

                Text("Earnings")
            }) {
                earningsSection
            }

            Section(header: Text("Fees"), footer: Text("Don't worry... all of this can be updated at any time!")) {
                feesSection
            }
            
//            Section(header: HStack {
//                Text("Deltas")
//                Spacer()
//                Button(action: {
//                    isShowingNewDeltaSheet = true
//                }) {
//                    Label("Add Delta", systemImage: "plus")
//                }
//            }) {
//                allDeltasSection
//            }
        }
        .navigationTitle("Prediction")
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbar }
        .sheet(isPresented: $isShowingNewDeltaSheet) {
            AddDeltaView(predictionId: viewModel.id)
        }
    }
}

// MARK: - Intro section
extension PredictionView {
    @ViewBuilder var introSection: some View {
        TextField("Name", text: $viewModel.name)
        
        DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
        
        HStack {
            Text("Initial Balance")
            CurrencyField("Initial Balance", value: $viewModel.startBalance, textAlignment: .right)
        }
    }
}

// MARK: - Deltas Section
extension PredictionView {
    @ViewBuilder var earningsSection: some View {
        List {
            ForEach(viewModel.earnings) { earning in
                NavigationLink(destination: DeltaView(delta: $viewModel.deltas[viewModel.getIndexOfDelta(withId: earning.id)], toolbarType: .navigation)) {
                    DeltaRowView(name: earning.name, value: earning.value, dates: earning.dates, dateRepetitionName: earning.dateRepetition.rawValue)
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .earnings)
            })
        }
    }
    
    @ViewBuilder var feesSection: some View {
        List {
            ForEach(viewModel.fees) { fee in
                NavigationLink(destination: DeltaView(delta: $viewModel.deltas[viewModel.getIndexOfDelta(withId: fee.id)], toolbarType: .navigation)) {
                    DeltaRowView(name: fee.name, value: fee.value, dates: fee.dates, dateRepetitionName: fee.dateRepetition.rawValue)
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .fees)
            })
        }
    }
    
    @ViewBuilder var allDeltasSection: some View {
        List {
            ForEach(viewModel.deltas) { delta in
                NavigationLink(destination: DeltaView(delta: $viewModel.deltas[viewModel.getIndexOfDelta(withId: delta.id)], toolbarType: .navigation)) {
                    DeltaRowView(name: delta.name, value: delta.value, dates: delta.dates, dateRepetitionName: delta.dateRepetition.rawValue)
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .all)
            })
        }
    }
}

// MARK: - Toolbar
extension PredictionView {
    @ToolbarContentBuilder var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            switch toolbarType {
            case .sheet:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            case .navigation:
                BackButton(action: viewModel.save)
                    .disabled(viewModel.isDisabled)
            }
        }
        
        ToolbarItem(placement: .confirmationAction) {
            switch toolbarType {
            case .sheet:
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(viewModel.isDisabled)
            case .navigation:
                EmptyView()
            }
        }
    }
}

// MARK: - Logger
extension PredictionView {
    static let logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "PredictionView")
}


// MARK: - Preview
struct PredictionView_Previews: PreviewProvider {
    static let predID = UUID()
    static let prediction = Prediction(
        id: predID,
        name: "Test",
        startBalance: -999_999.99,
        startDate: Date(),
        deltas: [Delta(id: UUID(), name: "Test", value: 1232.1, details: "Some more info", dates: [Date(), Date(timeInterval: 12321, since: Date())], positiveUncertainty: 21.1, negativeUncertainty: 123.1, dateRepetition: .custom, predictionId: predID)],
        details: "Here's a description"
    )
    
    static var previews: some View {
        NavigationView {
            PredictionView(viewModel: PredictionViewModel(prediction: prediction), toolbarType: .navigation)
        }
    }
}
