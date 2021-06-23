//
//  PredictionView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

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
                TextEditor(text: $viewModel.prediction.details)
            }
            
//            Section(header: VStack(alignment: .leading, spacing: 10) {
//                Button(action: {
//                    isShowingNewDeltaSheet = true
//                }) {
//                    Label("Add Earning/Fee", systemImage: "plus")
//                }
//
//                Text("Earnings")
//            }) {
//                earningsSection
//            }
//
//            Section(header: Text("Fees"), footer: Text("Don't worry... all of this can be updated at any time!")) {
//                feesSection
//            }
            
            Section(header: HStack {
                Text("Deltas")
                Spacer()
                Button(action: {
                    isShowingNewDeltaSheet = true
                }) {
                    Label("Add Delta", systemImage: "plus")
                }
            }) {
                allDeltasSection
            }
        }
        .navigationTitle("Prediction")
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbar }
        .sheet(isPresented: $isShowingNewDeltaSheet) {
            NavigationView {
                DeltaView(viewModel: DeltaViewModel(newFor: viewModel.prediction), toolbarType: .sheet)
            }
        }
    }
}

// MARK: - Intro section
extension PredictionView {
    @ViewBuilder var introSection: some View {
        TextField("Name", text: $viewModel.prediction.name)
        
        DatePicker("Start Date", selection: $viewModel.prediction.startDate, displayedComponents: .date)
        
        HStack {
            Text("Initial Balance")
            CurrencyField("Initial Balance", value: $viewModel.prediction.startBalance, textAlignment: .right)
        }
    }
}

// MARK: - Deltas Section
extension PredictionView {
    @ViewBuilder var earningsSection: some View {
        List {
            ForEach(viewModel.earnings) { earning in
                NavigationLink(destination: DeltaView(viewModel: DeltaViewModel(earning), toolbarType: .navigation)) {
                    DeltaRowView(delta: earning)
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
                NavigationLink(destination: DeltaView(viewModel: DeltaViewModel(fee), toolbarType: .navigation)) {
                    DeltaRowView(delta: fee)
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteDeltas(atOffsets: indexSet, deleteFrom: .fees)
            })
        }
    }
    
    @ViewBuilder var allDeltasSection: some View {
        List {
            ForEach(viewModel.prediction.deltas) { delta in
                NavigationLink(destination: DeltaView(viewModel: DeltaViewModel(delta), toolbarType: .navigation)) {
                    DeltaRowView(delta: delta)
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


// MARK: - Preview
struct PredictionView_Previews: PreviewProvider {
    static let prediction = Prediction(
        id: UUID(),
        name: "",
        startBalance: -999_999.99,
        startDate: Date(),
        deltas: [Delta()],
        details: ""
    )
    
    static var previews: some View {
        NavigationView {
            PredictionView(viewModel: PredictionViewModel(prediction: prediction), toolbarType: .navigation)
        }
    }
}
