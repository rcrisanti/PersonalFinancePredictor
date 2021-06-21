//
//  PredictionsView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/19/21.
//

import SwiftUI
import Combine

struct PredictionsView: View {
    @StateObject var viewModel: PredictionsViewModel
    @State private var isShowingNewPredictionSheet = false
    
    init(predictionPublisher: AnyPublisher<[PredictionCD], Never> = PredictionStorage.shared.predictions.eraseToAnyPublisher()) {
        _viewModel = StateObject(wrappedValue: PredictionsViewModel(predictionPublisher: predictionPublisher))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.predictions) { prediction in
                    NavigationLink(destination: PredictionView(viewModel: PredictionViewModel(prediction))) {
                        Text("Prediction \(prediction.name)")
                    }
                }
                .onDelete(perform: viewModel.deletePredictions)
            }
            .navigationBarTitle("Predictions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingNewPredictionSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isShowingNewPredictionSheet) {
                NavigationView {
                    PredictionEditView()
                }
            }
        }
    }
}

struct PredictionsView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsView()
    }
}
