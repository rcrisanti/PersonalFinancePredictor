//
//  DateCD+fromDate.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DateCD {
    static func fromDate(_ date: Date, for deltaCD: DeltaCD, withId: UUID? = nil) -> DateCD {
        let dateCD = DateCD(context: PersistenceController.shared.viewContext)
        if let id = withId {
            dateCD.id = id
        } else {
            dateCD.id = UUID()
        }
        dateCD.date = date
        dateCD.delta = deltaCD
        return dateCD
    }
}
