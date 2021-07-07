//
//  StepLineChartViewModel.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 7/5/21.
//

import Foundation

class StepLineChartViewModel: ObservableObject {
    @Published var normalizedDataSet: NormalizedDataSet {
        willSet {
            normalizedData = newValue.data.sorted(by: { $0.normX < $1.normX })
        }
    }
    @Published var normalizedData: [NormalizedDataPoint]
    
    init(dataSet: NormalizedDataSet) {
        normalizedDataSet = dataSet
        normalizedData = dataSet.data.sorted(by: { $0.normX < $1.normX })
    }
    
    var mainLineInitial: (x: Double, y: Double) {
        (normalizedData[0].normX, normalizedData[0].normY)
    }
    
    var mainLinePoints: [(x: Double, y: Double)] {
        Array(normalizedData[1...]).map { ($0.normX, $0.normY) }
    }
    
    var rangeInitial: (x: Double, y: Double) {
        (normalizedData[0].normX, normalizedData[0].normYRangeMax)
    }
    
    var rangePointsTop: [(x: Double, y: Double, lastY: Double)] {
        var ret = [(x: Double, y: Double, lastY: Double)]()
        for (i,point) in normalizedData.enumerated() {
            if i != 0 {
                ret.append((x: point.normX, y: point.normYRangeMax, lastY: normalizedData[i - 1].normYRangeMax))
            }
        }
        return ret
    }
    
    var rangePointsBottom: [(x: Double, nextX: Double, nextY: Double)] {
        var ret = [(x: Double, nextX: Double, nextY: Double)]()
        let reversed: [NormalizedDataPoint] = normalizedData.reversed()
        let len = reversed.count - 1
        for (i,point) in reversed.enumerated() {
            if i != len {
                ret.append((x: point.normX, nextX: reversed[i + 1].normX, nextY: reversed[i + 1].normYRangeMin))
            }
        }
        return ret
    }
    
    var isPlottable: Bool {
        normalizedData.count > 2
    }
}
