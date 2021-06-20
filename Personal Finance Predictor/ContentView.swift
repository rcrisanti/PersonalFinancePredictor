//
//  ContentView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import SwiftUI
import os.log

struct ContentView: View {
    var body: some View {
        PredictionsView()
    }

    static let logger = Logger(subsystem: "com.rcrisanti.Personal-Finance-Predictor", category: "ContentView")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
