//
//  PredictionTests.swift
//  Personal Finance PredictorTests
//
//  Created by Ryan Crisanti on 6/23/21.
//

import XCTest
@testable import Personal_Finance_Predictor

class PredictionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testToPredictionCDFromAutoInit() {
        let pred = Prediction(id: UUID(), name: "test", startBalance: 12.34, startDate: Date(), deltas: [], details: "test")
        let predCD = PredictionCD(prediction: pred)
        PersistenceController.shared.save()
        
        XCTAssert(pred.id == predCD.id, "IDs don't match")
        XCTAssert(pred.name == predCD.name, "Names don't match")
        XCTAssert(pred.startBalance == predCD.startBalance, "Start balances don't match")
        XCTAssert(pred.startDate == predCD.startDate, "Start dates don't match")
        XCTAssert(pred.details == predCD.details, "Details don't match")
        
        let deltasCD: [DeltaCD] = predCD.deltas?.allObjects as! [DeltaCD]
        let deltas = deltasCD.map { Delta($0) }
        XCTAssert(pred.deltas == deltas, "Deltas don't match")
    }
    
    func testToPredictionCDFromPrediction() {
        let predCD = PredictionCD(context: PersistenceController.shared.viewContext)
        predCD.id = UUID()
        predCD.name = "Test"
        predCD.details = "Details"
        predCD.startBalance = 213.12
        predCD.startDate = Date(timeInterval: 12314, since: Date())
        let deltaCD = DeltaCD.from(Delta())
        predCD.addToDeltas(deltaCD)
        PersistenceController.shared.save()
        XCTAssert(predCD.deltas?.count == 1)
        
        let pred = Prediction(predCD)
        let newPredCD = PredictionCD(prediction: pred)
        
        XCTAssert(predCD.id == newPredCD.id, "IDs are not the same")
        XCTAssert(predCD.name == newPredCD.name, "Names are not the same")
        XCTAssert(predCD.startBalance == newPredCD.startBalance, "Start balances are not the same")
        XCTAssert(predCD.startDate == newPredCD.startDate, "Start dates are not the same")
        XCTAssert(newPredCD.deltas?.count == 1)
        XCTAssert(predCD.details == newPredCD.details, "Details are not the same")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
