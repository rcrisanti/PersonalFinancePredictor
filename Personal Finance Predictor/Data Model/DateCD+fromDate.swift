//
//  DateCD+fromDate.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import Foundation

extension DateCD {
    static func from(_ date: Date, for deltaCD: DeltaCD? = nil, withId id: UUID? = nil) -> DateCD {
        if let id = id {
            if let dateCD = PredictionStorage.shared.getDate(withId: id) {
                dateCD.update(from: date, for: deltaCD, withId: id)
                return dateCD
            } else {
                let dateCD = DateCD(context: PersistenceController.shared.viewContext)
                dateCD.id = id
                dateCD.date = date
                
                if let deltaCD = deltaCD {
                    dateCD.delta = deltaCD
                } else {
                    dateCD.delta = DeltaCD(delta: Delta())
                }
                PersistenceController.shared.save()
                return dateCD
            }
        } else {
            let dateCD = DateCD(context: PersistenceController.shared.viewContext)
            dateCD.id = UUID()
            dateCD.date = date
            
            if let deltaCD = deltaCD {
                dateCD.delta = deltaCD
            } else {
                dateCD.delta = DeltaCD(delta: Delta())
            }
            PersistenceController.shared.save()
            return dateCD
        }
    }
    
    func update(from date: Date, for deltaCD: DeltaCD? = nil, withId id: UUID? = nil) {
        self.date = date
        if let deltaCD = deltaCD {
            self.delta = deltaCD
        }
        if let id = id {
            self.id = id
        }
        PersistenceController.shared.save()
    }
}
