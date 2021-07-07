//
//  NormalizedDataPoint.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/28/21.
//

import Foundation

struct NormalizedDataPoint: Hashable {
    var normX: Double {
        didSet { normX = bound(normX) }
    }
    
    var normY: Double {
        didSet { normY = bound(normY) }
    }
    
    var normYRangeMin: Double {
        didSet { normYRangeMin = bound(normYRangeMin) }
    }
    
    var normYRangeMax: Double {
        didSet { normYRangeMax = bound(normYRangeMax) }
    }
    
    var xLabel: String
    var yLabel: String
}

extension NormalizedDataPoint {
    init(dataPoint: DataPoint, minDate: Date, maxDate: Date, yMin: Double, yMax: Double, xLabel: String, yLabel: String) {
        let xRange = (maxDate.timeIntervalSince1970 - minDate.timeIntervalSince1970)
        let yRange = (yMax - yMin)
        
        normX = 0
        normY = 0
        normYRangeMin = 0
        normYRangeMax = 0
        
        self.xLabel = xLabel
        self.yLabel = yLabel
        
        normX = bound((dataPoint.date.timeIntervalSince1970 - minDate.timeIntervalSince1970) / xRange, invert: false)
        normY = bound((dataPoint.value - yMin) / yRange)
        normYRangeMin = bound((dataPoint.minRange - yMin) / yRange)
        normYRangeMax = bound((dataPoint.maxRange - yMin) / yRange)
    }
    
    func bound(_ value: Double, between min: Double = 0, and max: Double = 1, invert: Bool = true) -> Double {
        var bounded: Double = 0
        if value < min {
            bounded = min
        } else if value > max {
            bounded = max
        } else {
            bounded = value
        }
        
        if invert {
            return max - bounded + min
        } else {
            return bounded
        }
    }
}

extension NormalizedDataPoint: CustomStringConvertible {
    var description: String {
        "NormalizedDataPoint(normX: \(normX), normY: \(normY), normYRangeMin: \(normYRangeMin), normYRangeMax: \(normYRangeMax))"
    }
}
