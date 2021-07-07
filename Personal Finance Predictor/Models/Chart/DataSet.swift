//
//  DataSet.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/27/21.
//

import Foundation

struct DataSet {
    private var internalData: [DataPoint]
    
    init(data: [DataPoint]) {
        self.internalData = data
    }
    
    var data: [DataPoint] {
        internalData.sorted(by: { $0.date < $1.date } )
    }
    
    var minDate: Date {
        data.first!.date
    }
    
    var maxDate: Date {
        data.last!.date
    }
    
    var minValue: Double {
        data.min(by: { $0.minRange < $1.minRange } )?.minRange ?? 0
    }
    
    var maxValue: Double {
        data.max(by: { $0.maxRange < $1.maxRange } )?.maxRange ?? 0
    }
        
    func getNormalizedData() -> [NormalizedDataPoint] {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
        return data.map {
                NormalizedDataPoint(
                    dataPoint: $0,
                    minDate: minDate,
                    maxDate: maxDate,
                    yMin: minValue,
                    yMax: maxValue,
                    xLabel: formatter.string(from: $0.date),
                    yLabel: "\($0.value)"
                )
            }
    }
}
