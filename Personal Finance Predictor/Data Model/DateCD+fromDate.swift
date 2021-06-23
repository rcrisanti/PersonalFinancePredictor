//
//  DateCD+fromDate.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DateCD {
    convenience init(date: Date, for deltaCD: DeltaCD, withId: UUID? = nil) {
        self.init(context: PersistenceController.shared.viewContext)
        if let id = withId {
            self.id = id
        } else {
            self.id = UUID()
        }
        self.date = date
        delta = deltaCD
    }
}
