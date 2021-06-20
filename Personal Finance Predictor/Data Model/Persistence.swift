//
//  Persistence.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import CoreData
import os.log

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Make some test objects
        let delta = DeltaCD(context: viewContext)
        delta.name = "Test Delta"
        delta.value = 123.4
        delta.positiveUncertainty = 20
        delta.negativeUncertainty = 20
        delta.details = "Here is a longer description"
        
        let prediction = PredictionCD(context: viewContext)
        prediction.name = "Test prediction"
        prediction.startBalance = 12345.67
        prediction.startDate = Date()
        prediction.details = "Here is all I know about this prediction"
        prediction.addToDeltas(delta)

        // Save them
        do {
            try viewContext.save()
        } catch {
            Self.logger.error("Cannot save preview view context: \(error.localizedDescription)")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Personal_Finance_Predictor")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                Self.logger.error("Cannot load persistent stores: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var viewContext: NSManagedObjectContext {
        self.container.viewContext
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                Self.logger.debug("Saved view context successfully")
            } catch {
                Self.logger.error("Error saving view context: \(error.localizedDescription)")
            }
        } else {
            Self.logger.debug("No changes, not saving view context")
        }
    }
    
    // MARK: - Fetches
    func fetchPredictions() -> [PredictionCD] {
        let request: NSFetchRequest<PredictionCD> = PredictionCD.fetchRequest()
        
        do {
            let predictionsCD = try viewContext.fetch(request)
            return predictionsCD
        } catch {
            Self.logger.error("Unable to fetch predictions")
            return []
        }
    }
    
    static var logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "Persistence")
}
