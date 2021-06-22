//
//  PredictionsView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/19/21.
//

import SwiftUI
import Combine
import os.log
import CoreData

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
    
    func deleteAll(_ entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try PersistenceController.shared.viewContext.execute(deleteRequest)
        } catch {
            Self.logger.error("Could not delete all \(entityName): \(error.localizedDescription)")
        }
    }
    
    static var logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "PredictionsView")
}

struct PredictionsView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsView()
    }
}
