//
//  NormalizedDataSet.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 7/5/21.
//

import Foundation

struct NormalizedDataSet {
    var data: [NormalizedDataPoint]
    
    init(normalizedData: [NormalizedDataPoint]) {
        data = normalizedData
    }
    
    init(dataSet: DataSet) {
        data = dataSet.getNormalizedData()
    }
}
