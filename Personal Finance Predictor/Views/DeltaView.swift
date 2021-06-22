//
//  DeltaView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import SwiftUI

struct DeltaView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = DeltaViewModel()
    @State private var uncertaintySamePositiveNegative = true
    @State private var singleUncertaintyValue: Double = 0
    @State private var showingSymmetricUncertaintyAboutAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $viewModel.delta.name)
                    
                    HStack {
                        Text("Value")
                        CurrencyField("Value", value: $viewModel.delta.value, textAlignment: .right)
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $viewModel.delta.details)
                }
                
                Section(header: Text("Uncertainty")) {
                    Toggle(isOn: $uncertaintySamePositiveNegative) {
                        HStack {
                            Text("Symmetric")
                            Button(action: {
                                showingSymmetricUncertaintyAboutAlert.toggle()
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    
                    HStack {
                        if uncertaintySamePositiveNegative {
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
                    
                    if !uncertaintySamePositiveNegative {
                        HStack {
                            Text("Negative Value")
                            CurrencyField("Negative Value", value: $viewModel.delta.negativeUncertainty, textAlignment: .right)
                        }
                    }
                }
                
                Section(header: Text("Dates")) {
                    Picker("Repetition", selection: $viewModel.delta.dateRepetition) {
                        ForEach(DateRepetition.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
//                    .pickerStyle(MenuPickerStyle())
                    
                    
                }
            }
            .navigationBarTitle("New Delta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingSymmetricUncertaintyAboutAlert) {
                Alert(
                    title: Text("Symmetric Uncertainty"),
                    message: Text("If the value of uncertainty in the positive & negative directions is equal, your uncertainty is symmetric. If not, then it's not!"),
                    dismissButton: .default(Text("OK")) { showingSymmetricUncertaintyAboutAlert = false }
                )
            }
        }
    }
}

struct DeltaView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaView()
    }
}
