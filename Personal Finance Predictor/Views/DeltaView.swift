//
//  DeltaView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import SwiftUI
import os.log

struct DeltaView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    @State private var singleUncertaintyValue: Double = 0
    @State private var activeAlert: AboutAlerts?
    
    @StateObject var viewModel: DeltaViewModel
    let toolbarType: ToolbarType
    let saveOnScenePhase: Bool
    
    init(delta: Binding<Delta>, toolbarType: ToolbarType, saveOnScenePhase: Bool = true) {
        self.toolbarType = toolbarType
        self.saveOnScenePhase = saveOnScenePhase
        _viewModel = StateObject(wrappedValue: DeltaViewModel(delta: delta))
    }
        
    var body: some View {
        Form {
            Section {
                introSection
            }
            
            Section(header: Text("Description")) {
                TextEditor(text: $viewModel.details)
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
                    viewModel.addDate()
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
        .onAppear {
            if viewModel.uncertaintyIsSymmetric {
                singleUncertaintyValue = viewModel.positiveUncertainty
            } else {
                singleUncertaintyValue = max(viewModel.positiveUncertainty, viewModel.negativeUncertainty)
            }
        }
        .onChange(of: scenePhase) {_ in
            if saveOnScenePhase {
                viewModel.save()
            }
        }
    }
}

// MARK: - Intro section
extension DeltaView {
    @ViewBuilder var introSection: some View {
        TextField("Name", text: $viewModel.name)
        
        HStack {
            Text("Value")
            Button(action: {
                activeAlert = .value
            }) {
                Image(systemName: "questionmark.circle")
            }
            CurrencyField("Value", value: $viewModel.value, textAlignment: .right)
        }
    }
}

// MARK: - Uncertainty section
extension DeltaView {
    @ViewBuilder var uncertaintySection: some View {
        Toggle(isOn: $viewModel.uncertaintyIsSymmetric) {
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
            if viewModel.uncertaintyIsSymmetric {
                Text("Value")
                CurrencyField("Value", value: $singleUncertaintyValue, textAlignment: .right, onReturn: {
                    viewModel.setBothUncertainties(to: singleUncertaintyValue)
                }, onEditingChanged: { _ in
                    viewModel.setBothUncertainties(to: singleUncertaintyValue)
                })
            } else {
                Text("Positive Value")
                CurrencyField("Positive Value", value: $viewModel.positiveUncertainty, textAlignment: .right)
            }
        }
        
        if !viewModel.uncertaintyIsSymmetric {
            HStack {
                Text("Negative Value")
                CurrencyField("Negative Value", value: $viewModel.negativeUncertainty, textAlignment: .right)
            }
        }
    }
}

// MARK: - Dates section
extension DeltaView {
    @ViewBuilder var datesSection: some View {
        Picker("Repetition", selection: $viewModel.dateRepetition) {
            ForEach(DateRepetition.allCases) {
                Text($0.rawValue.capitalized).tag($0)
            }
        }
//        .pickerStyle(MenuPickerStyle())
    }
    
    @ViewBuilder var customDatesSection: some View {
        List {
            ForEach(viewModel.dates.indices, id: \.self) { dateIndex in
                DatePicker(
                    dateIndex == 0
                        ? "Earliest Date" :
                        (dateIndex == viewModel.dates.count - 1
                            ? "Latest Date"
                            : ""),
                    selection: $viewModel.dates[dateIndex],
                    displayedComponents: .date
                )
                .onChange(of: viewModel.dates, perform: { _ in
                    withAnimation {
                        viewModel.sortDates(deadline: .now() + 1)
                    }
                })
                
            }
            .onDelete(perform: viewModel.deleteDates)
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
                    presentationMode.wrappedValue.dismiss()
                }
            case .navigation:
                BackButton(action: {
                    viewModel.save()
                })
                .disabled(viewModel.name.isEmpty)
            }
        }
        
        ToolbarItem(placement: .confirmationAction) {
            switch toolbarType {
            case .sheet:
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(viewModel.name.isEmpty)
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

// MARK: - Logger
extension DeltaView {
    static let logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "DeltaView")
}

// MARK: - Previews
struct DeltaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeltaView(
                delta: .constant(Delta(
                    id: UUID(),
                    name: "Test",
                    value: 1231,
                    details: "some more info",
                    dates: [Date(), Date(timeInterval: 2131, since: Date())],
                    positiveUncertainty: 12.2,
                    negativeUncertainty: 14.2,
                    dateRepetition: .custom,
                    predictionId: UUID()
                )),
                toolbarType: .navigation
            )
        }
    }
}
