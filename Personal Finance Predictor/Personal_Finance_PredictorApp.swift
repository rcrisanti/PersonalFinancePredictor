//
//  Personal_Finance_PredictorApp.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import SwiftUI

@main
struct Personal_Finance_PredictorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
