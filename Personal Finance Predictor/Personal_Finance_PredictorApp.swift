//
//  Personal_Finance_PredictorApp.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import SwiftUI

@main
struct Personal_Finance_PredictorApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.shared.save()
        }
    }
}
