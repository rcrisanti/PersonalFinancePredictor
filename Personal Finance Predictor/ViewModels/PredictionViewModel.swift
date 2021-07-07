//
//  PredictionViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/17/21.
//

import Foundation
import SwiftUI
import Combine
import os.log
import SwiftUICharts

enum DeltaFilter {
    case earnings, fees, all
}

class PredictionViewModel: ObservableObject {
    @Published private var prediction: Prediction
    
    func getIndexOfDelta(withId id: UUID) -> Int {
        guard let index = deltas.firstIndex(where: { $0.id == id }) else {
            Self.logger.critical("Could not find index of Delta with ID \(id.uuidString) - returning an index of 0")
            return 0
        }
        return index
    }

    
    // MARK: - Basic properties & init
    var id: UUID {
        get { prediction.id }
    }
    
    var name: String {
        get { prediction.name }
        set { prediction.name = newValue }
    }
    
    var startBalance: Double {
        get { prediction.startBalance }
        set { prediction.startBalance = newValue }
    }
    
    var startDate: Date {
        get { prediction.startDate }
        set { prediction.startDate = newValue }
    }
    
    var deltas: [Delta] {
        get { prediction.deltas }
        set {
            prediction.deltas = newValue
            earnings = getEarnings(from: newValue)
            fees = getFees(from: newValue)
        }
    }
    
    var details: String {
        get { prediction.details }
        set { prediction.details = newValue }
    }
                
    init(prediction: Prediction = Prediction()) {
        self.prediction = prediction
        earnings = getEarnings(from: prediction.deltas)
        fees = getFees(from: prediction.deltas)
    }
    
    // MARK: - Helper computed properties
    var isDisabled: Bool {
        prediction.name.isEmpty
    }
    
    @Published var earnings: [Delta] = []

    @Published var fees: [Delta] = []
    
    func getEarnings(from deltas: [Delta]) -> [Delta] {
        deltas.filter { $0.value >= 0 }.sorted(by: { abs($0.value) > abs($1.value) })
    }
    
    func getFees(from deltas: [Delta]) -> [Delta] {
        deltas.filter { $0.value < 0 }.sorted(by: { abs($0.value) > abs($1.value) })
    }
    
    // MARK: - Save, Delete, Add, Cancel
    func save() {
        if let predictionCD = PredictionStorage.shared.getPrediction(withId: prediction.id) {
            predictionCD.update(from: prediction)
        } else {
            _ = PredictionCD(prediction: prediction)
        }
        PersistenceController.shared.save()
    }
    
    func deleteDeltas(atOffsets: IndexSet, deleteFrom: DeltaFilter = .all) {
        for index in atOffsets {
            switch deleteFrom {
            case .all:
                deltas.remove(at: index)
            case .fees:
                let toRemove = fees[index]
                if let foundIndex = prediction.deltas.firstIndex(where: { $0.id == toRemove.id }) {
                    deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            case .earnings:
                let toRemove = earnings[index]
                if let foundIndex = prediction.deltas.firstIndex(where: { $0.id == toRemove.id }) {
                    deltas.remove(at: foundIndex)
                } else {
                    Self.logger.warning("Could not find Delta \(toRemove.name) in Prediction deltas")
                }
            }
        }
    }
    
    // MARK: - Get data in format for plotting
    var chartData: RangedLineChartData {
        let pointStyle = PointStyle()
        let style = RangedLineStyle(lineColour: ColourStyle(colour: .red), fillColour: ColourStyle(colour: .green), lineType: .curvedLine, strokeStyle: Stroke(), ignoreZero: true)
        
        let dataSets = RangedLineDataSet(
            dataPoints: [
                RangedLineChartDataPoint(value: 1234, upperValue: 1230, lowerValue: 1240, xAxisLabel: "xAxisLabel", description: "Description", date: Date()),
                RangedLineChartDataPoint(value: 1237, upperValue: 1224, lowerValue: 1238, xAxisLabel: "xAxisLabel", description: "Description", date: Date(timeInterval: 12312, since: Date())),
                RangedLineChartDataPoint(value: 1240, upperValue: 1222, lowerValue: 1245, xAxisLabel: "xAxisLabel", description: "Description", date: Date(timeInterval: 1234212, since: Date()))
            ],
            legendTitle: "Prediction",
            legendFillTitle: "Uncertainty",
            pointStyle: pointStyle,
            style: style
        )
        
        let metaData = ChartMetadata(
            title: "Chart title",
            subtitle: "Subtitle"//,
//            titleFont: .headline,
//            titleColour: .green,
//            subtitleFont: .caption,
//            subtitleColour: .red
        )
        
//        let chartStyle = LineChartStyle(
//            infoBoxPlacement: .floating, infoBoxContentAlignment: .horizontal, infoBoxValueFont: .body, infoBoxValueColour: .red, infoBoxDescriptionFont: .headline, infoBoxDescriptionColour: .green, infoBoxBackgroundColour: .gray, infoBoxBorderColour: .yellow)
        
        
        let data = RangedLineChartData(
            dataSets: dataSets,
            metadata: metaData,
//            chartStyle: chartStyle,
            noDataText: Text("No Data")
        )
        
        return data
    }
    
    
    // MARK: - Logger
    static let logger = Logger(subsystem: "com.rcisanti.Personal-Finance-Predictor", category: "PredictionViewModel")
}
