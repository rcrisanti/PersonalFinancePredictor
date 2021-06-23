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
    @State private var showingDeleteAllAlert = false
    
    init(predictionPublisher: AnyPublisher<[PredictionCD], Never> = PredictionStorage.shared.predictions.eraseToAnyPublisher()) {
        _viewModel = StateObject(wrappedValue: PredictionsViewModel(predictionPublisher: predictionPublisher))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.predictions) { prediction in
                    NavigationLink(destination: PredictionView(viewModel: PredictionViewModel(prediction: prediction), toolbarType: .navigation)) {
                        PredictionRowView(prediction: prediction)
                    }
                }
                .onDelete(perform: viewModel.deletePredictions)
            }
            .navigationBarTitle("Predictions")
            .toolbar { toolbar }
            .sheet(isPresented: $isShowingNewPredictionSheet) {
                NavigationView {
                    PredictionView(toolbarType: .sheet)
                }
            }
            .alert(isPresented: $showingDeleteAllAlert) { deleteAllAlert }
        }
    }
    
    static var logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "PredictionsView")
}

// MARK: - Toolbar
extension PredictionsView {
    @ToolbarContentBuilder var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {
                    showingDeleteAllAlert = true
                }) {
                    Label("Delete All", systemImage: "exclamationmark.triangle")
                }
            } label: {
                Label("Menu", systemImage: "line.horizontal.3")
            }
            
            Button(action: {
                isShowingNewPredictionSheet = true
            }) {
                Image(systemName: "plus")
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
    
    var deleteAllAlert: Alert {
        Alert(
            title: Text("Delete all data?"),
            message: Text("This action cannot be undone. To successfully see a cleared app, you may need to quit the app."),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("I'm sure I don't want my data anymore")) {
                deleteAll("DateCD")
                deleteAll("DeltaCD")
                deleteAll("PredictionCD")
                PersistenceController.shared.save()
            }
        )
    }
}

// MARK: - Previews
struct PredictionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PredictionsView()
            PredictionsView()
        }
    }
}
