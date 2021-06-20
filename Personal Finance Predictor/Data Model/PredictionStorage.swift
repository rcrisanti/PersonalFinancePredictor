//
//  PredictionStorage.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/19/21.
//

import Foundation
import Combine
import CoreData
import os.log

class PredictionStorage: NSObject, ObservableObject {
    var predictions = CurrentValueSubject<[PredictionCD], Never>([])
    private let predictionFetchController: NSFetchedResultsController<PredictionCD>
    
    static let shared: PredictionStorage = PredictionStorage()
    
    private override init() {
        let fetchRequest: NSFetchRequest<PredictionCD> = PredictionCD.fetchRequest()
        fetchRequest.sortDescriptors = []
        predictionFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        predictionFetchController.delegate = self
        
        do {
            try predictionFetchController.performFetch()
            predictions.value = predictionFetchController.fetchedObjects ?? []
        } catch {
            Self.logger.notice("Error fetching PredictionCD objects")
        }
    }
    
    func add() {
//        Self.logger.notice("Add functionality not yet implemented")
        
        let prediction = PredictionCD(context: PersistenceController.shared.viewContext)
        prediction.id = UUID()
        prediction.name = "Test prediction"
        prediction.startBalance = 12345.67
        prediction.startDate = Date()
        prediction.details = "Here is all I know about this prediction"
        
        PersistenceController.shared.save()
    }
    
    func delete(_ prediction: PredictionCD) {
//        Self.logger.notice("Delete functionality not yet implemented")
        
        PersistenceController.shared.viewContext.delete(prediction)
        PersistenceController.shared.save()
    }
    
    func update() {
        Self.logger.notice("Update functionality not yet implemented")
    }
    
    func getPrediction(withId: UUID) throws -> PredictionCD {
        if let prediction = predictions.value.first(where: { $0.id == withId } ) {
            return prediction
        } else {
            throw PredictionStorageError.NoMatchingObject("No PredictionCD with ID \(withId.uuidString)")
        }
    }
    
    static let logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "PredictionStorage")
}

extension PredictionStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let predictions = controller.fetchedObjects as? [PredictionCD] else { return }
        Self.logger.info("Context has changed, reloading predictions")
        self.predictions.value = predictions
    }
}

enum PredictionStorageError: Error {
    case NoMatchingObject(_ msg: String)
}
