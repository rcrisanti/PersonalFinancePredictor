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
            
//            StepLineChartView(
//                dataSet: DataSet(
//                    data: [
//                        DataPoint(
//                            date: Date(),
//                            value: 1,
//                            minRange: 0,
//                            maxRange: 2
//                        ),
//                        DataPoint(
//                            date: Date(timeInterval: 123, since: Date()),
//                            value: 2,
//                            minRange: 1,
//                            maxRange: 3
//                        ),
//                        DataPoint(
//                            date: Date(timeInterval: 150, since: Date()),
//                            value: 3,
//                            minRange: 2,
//                            maxRange: 4
//                        )
//                    ]
//                )
//            )
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.shared.save()
        }
    }
}
