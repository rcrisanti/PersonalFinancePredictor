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
    
    func delete(_ prediction: PredictionCD) {
        PersistenceController.shared.viewContext.delete(prediction)
        PersistenceController.shared.save()
    }
    
    func getPrediction(withId: UUID) -> PredictionCD? {
        guard let prediction = predictions.value.first(where: { $0.id == withId } ) else {
            Self.logger.warning("Could not find a PredictionCD with id \(withId.uuidString)")
            return nil
        }
        return prediction
    }
    
    func getDelta(withId: UUID) -> DeltaCD? {
        let nestedDeltas: [[DeltaCD]] = predictions.value.map { $0.deltas?.allObjects as! [DeltaCD] }
        
        let deltas = nestedDeltas.joined()
        
        guard let delta = deltas.first(where: { $0.id == withId } ) else {
            Self.logger.warning("Could not find a DeltaCD with id \(withId.uuidString)")
            return nil
        }
        return delta
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
