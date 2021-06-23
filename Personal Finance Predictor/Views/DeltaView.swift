//
//  DeltaView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import SwiftUI

struct DeltaView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DeltaViewModel
    @State private var uncertaintyIsSymmetric = true
    @State private var singleUncertaintyValue: Double = 0
    @State private var activeAlert: AboutAlerts?
    
    let toolbarType: ToolbarType
    
    init(viewModel: DeltaViewModel = DeltaViewModel(), toolbarType: ToolbarType) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.toolbarType = toolbarType
    }
    
    var body: some View {
        Form {
            Section {
                introSection
            }
            
            Section(header: Text("Description")) {
                TextEditor(text: $viewModel.delta.details)
            }
            
            Section(header: Text("Uncertainty")) {
                uncertaintySection
            }
            
            Section(header: Text("Dates")) {
                datesSection
            }
            
            Section(header: HStack {
                Spacer()
                Button(action: {
                    viewModel.delta.dates.append(Date())
                }) {
                    Label("Add Date", systemImage: "plus")
                }
            }) {
                customDatesSection
            }
        }
        .navigationBarTitle("Delta")
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbar }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .value:
                return valueAboutAlert
            case .symmetricUncertainty:
                return symmetricUncertaintyAboutAlert
            }
        }
    }
}

// MARK: - Intro section
extension DeltaView {
    @ViewBuilder var introSection: some View {
        TextField("Name", text: $viewModel.delta.name)
        
        HStack {
            Text("Value")
            Button(action: {
                activeAlert = .value
            }) {
                Image(systemName: "questionmark.circle")
            }
            CurrencyField("Value", value: $viewModel.delta.value, textAlignment: .right)
        }
    }
}

// MARK: - Uncertainty section
extension DeltaView {
    @ViewBuilder var uncertaintySection: some View {
        Toggle(isOn: $uncertaintyIsSymmetric) {
            HStack {
                Text("Symmetric")
                Button(action: {
                    activeAlert = .symmetricUncertainty
                }) {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        
        HStack {
            if uncertaintyIsSymmetric {
                Text("Value")
                CurrencyField("Value", value: $singleUncertaintyValue, textAlignment: .right, onReturn: {
                    viewModel.setUncertainty(singleUncertaintyValue)
                }, onEditingChanged: { _ in
                    viewModel.setUncertainty(singleUncertaintyValue)
                })
            } else {
                Text("Positive Value")
                CurrencyField("Positive Value", value: $viewModel.delta.positiveUncertainty, textAlignment: .right)
            }
        }
        
        if !uncertaintyIsSymmetric {
            HStack {
                Text("Negative Value")
                CurrencyField("Negative Value", value: $viewModel.delta.negativeUncertainty, textAlignment: .right)
            }
        }
    }
}

// MARK: - Dates section
extension DeltaView {
    @ViewBuilder var datesSection: some View {
        Picker("Repetition", selection: $viewModel.delta.dateRepetition) {
            ForEach(DateRepetition.allCases) {
                Text($0.rawValue.capitalized).tag($0)
            }
        }
//        .pickerStyle(MenuPickerStyle())
    }
    
    @ViewBuilder var customDatesSection: some View {
        List {
            ForEach(viewModel.sortedDates.indices, id: \.self) { dateIndex in
                DatePicker(
                    dateIndex == 0
                        ? "Earliest Date" :
                        (dateIndex == viewModel.sortedDates.count - 1
                            ? "Latest Date"
                            : ""),
                    selection: $viewModel.sortedDates[dateIndex],
                    displayedComponents: .date
                )
            }
            .onDelete(perform: viewModel.deleteSortedDates)
        }
    }
}

// MARK: - Toolbar
extension DeltaView {
    @ToolbarContentBuilder var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            switch toolbarType {
            case .sheet:
                Button("Cancel") {
                    viewModel.cancel()
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

// MARK: - Alerts
extension DeltaView {
    enum AboutAlerts: String, Identifiable {
        case value, symmetricUncertainty
        
        var id: String {
            self.rawValue
        }
    }
    
    var valueAboutAlert: Alert {
        Alert(
            title: Text("Delta Value"),
            message: Text("If this delta is making you money, make this value a positive number. If it's costing you money, make it negative."),
            dismissButton: .default(Text("Got it!")) {
                activeAlert = nil
            }
        )
    }
    
    var symmetricUncertaintyAboutAlert: Alert {
        Alert(
            title: Text("Symmetric Uncertainty"),
            message: Text("If the value of uncertainty in the positive & negative directions is equal, your uncertainty is symmetric. If not, then it's not!"),
            dismissButton: .default(Text("Got it!")) {
                activeAlert = nil
            }
        )
    }
}

// MARK: - Previews
struct DeltaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeltaView(toolbarType: .navigation)
        }
    }
}
