//
//  Delta.swift
//  Personal Finance PredictorTests
//
//  Created by Ryan Crisanti on 6/23/21.
//

import XCTest
@testable import Personal_Finance_Predictor

class DeltaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testToDeltaCDFromAutoInit() throws {
        // Once with no predictionId supplied
        let delta1 = Delta(id: UUID(), name: "test", value: 1.1, details: "details", dates: [Date()], positiveUncertainty: 1.2, negativeUncertainty: 23.1, dateRepetition: .custom, predictionId: nil)
        let deltaCD1 = DeltaCD.from(delta1)
        
        XCTAssert(deltaCD1.id == delta1.id, "IDs do not match")
        XCTAssert(deltaCD1.name == delta1.name, "Names do not match")
        XCTAssert(deltaCD1.value == delta1.value, "Values do not match")
        XCTAssert(deltaCD1.details == delta1.details, "Details do not match")
        
        let datesCD1: [DateCD] = deltaCD1.dates?.allObjects as! [DateCD]
        let dates1 = datesCD1.map { $0.date ?? Date() }
        XCTAssert(dates1 == delta1.dates, "Dates do not match")
        XCTAssert(deltaCD1.positiveUncertainty == delta1.positiveUncertainty, "Positive uncertainties do not match")
        XCTAssert(deltaCD1.negativeUncertainty == delta1.negativeUncertainty, "Negative uncertainteis do not match")
        XCTAssert(deltaCD1.dateRepetition == delta1.dateRepetition.rawValue, "Date repetitions do not match")
        
        // Once with predictionId supplied
        let delta2 = Delta(id: UUID(), name: "test", value: 1.1, details: "details", dates: [Date()], positiveUncertainty: 1.2, negativeUncertainty: 23.1, dateRepetition: .custom, predictionId: UUID())
        let deltaCD2 = DeltaCD.from(delta2)
        XCTAssert(deltaCD2.id == delta2.id, "IDs do not match")
        XCTAssert(deltaCD2.name == delta2.name, "Names do not match")
        XCTAssert(deltaCD2.value == delta2.value, "Values do not match")
        XCTAssert(deltaCD2.details == delta2.details, "Details do not match")
        
        let datesCD2: [DateCD] = deltaCD2.dates?.allObjects as! [DateCD]
        let dates2 = datesCD2.map { $0.date ?? Date() }
        XCTAssert(dates2 == delta2.dates, "Dates do not match")
        XCTAssert(deltaCD2.positiveUncertainty == delta2.positiveUncertainty, "Positive uncertainties do not match")
        XCTAssert(deltaCD2.negativeUncertainty == delta2.negativeUncertainty, "Negative uncertainteis do not match")
        XCTAssert(deltaCD2.dateRepetition == delta2.dateRepetition.rawValue, "Date repetitions do not match")
        XCTAssert(deltaCD2.prediction?.id == delta2.predictionId, "Prediction IDs do not match")
    }

    func testToDeltaCDFromPredictionNotCreated() throws {
        let delta = Delta(for: Prediction())
        let deltaCD = DeltaCD.from(delta)
        
        XCTAssert(deltaCD.id == delta.id, "IDs do not match")
        XCTAssert(deltaCD.name == delta.name, "Names do not match")
        XCTAssert(deltaCD.value == delta.value, "Values do not match")
        XCTAssert(deltaCD.details == delta.details, "Details do not match")
        
        let datesCD: [DateCD] = deltaCD.dates?.allObjects as! [DateCD]
        let dates = datesCD.map { $0.date ?? Date() }
        XCTAssert(dates == delta.dates, "Dates do not match")
        XCTAssert(deltaCD.positiveUncertainty == delta.positiveUncertainty, "Positive uncertainties do not match")
        XCTAssert(deltaCD.negativeUncertainty == delta.negativeUncertainty, "Negative uncertainteis do not match")
        XCTAssert(deltaCD.dateRepetition == delta.dateRepetition.rawValue, "Date repetitions do not match")
        XCTAssert(deltaCD.prediction?.id == delta.predictionId, "Prediction IDs do not match")
    }
    
    func testToDeltaCDFromPredictionCreated() throws {
        let prediction = Prediction()
        let _ = PredictionCD(prediction: prediction)
        PersistenceController.shared.save()
        
        let delta = Delta(for: prediction)
        let deltaCD = DeltaCD.from(delta)
        
        XCTAssert(deltaCD.id == delta.id, "IDs do not match")
        XCTAssert(deltaCD.name == delta.name, "Names do not match")
        XCTAssert(deltaCD.value == delta.value, "Values do not match")
        XCTAssert(deltaCD.details == delta.details, "Details do not match")
        
        let datesCD: [DateCD] = deltaCD.dates?.allObjects as! [DateCD]
        let dates = datesCD.map { $0.date ?? Date() }
        XCTAssert(dates == delta.dates, "Dates do not match")
        XCTAssert(deltaCD.positiveUncertainty == delta.positiveUncertainty, "Positive uncertainties do not match")
        XCTAssert(deltaCD.negativeUncertainty == delta.negativeUncertainty, "Negative uncertainteis do not match")
        XCTAssert(deltaCD.dateRepetition == delta.dateRepetition.rawValue, "Date repetitions do not match")
        XCTAssert(deltaCD.prediction?.id == delta.predictionId, "Prediction IDs do not match")
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
