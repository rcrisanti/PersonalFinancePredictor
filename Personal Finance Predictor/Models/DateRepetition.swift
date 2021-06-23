//
//  DateRepetition.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/22/21.
//

import Foundation

enum DateRepetition: String, CaseIterable, Identifiable {
//    case yearly, monthy, weekly, daily, custom
    case custom

    var id: String {
        self.rawValue
    }
}

//enum DateRepetition {
//    case yearly(month: Int, day: Int)
//    case monthly(day: Int)
//    case weekly(dayOfWeek: String)
//    case daily
//    case custom
//}
//
//extension DateRepetition: RawRepresentable {
//    init?(rawValue: String) {
//        switch rawValue {
//        case "Yearly":
//            self = .yearly(month: 1, day: 1)
//        case "Monthly":
//            self = .monthly(day: 1)
//        case "Weekly":
//            self = .weekly(dayOfWeek: "Monday")
//        case "Daily":
//            self = .daily
//        case "Custom":
//            self = .custom
//        default:
//            return nil
//        }
//    }
//
//    var rawValue: String {
//        switch self {
//        case .yearly:
//            return "Yearly"
//        case .monthly:
//            return "Monthly"
//        case .weekly:
//            return "Weekly"
//        case .daily:
//            return "Daily"
//        case .custom:
//            return "Custom"
//        }
//    }
//
//    typealias RawValue = String
//}
//
//extension DateRepetition: CaseIterable, Identifiable {
//    static var allCases: [DateRepetition] = [.yearly(month: 1, day: 1), .monthly(day: 1), .weekly(dayOfWeek: "Monday"), .daily, .custom]
//
//    var id: String {
//        self.rawValue
//    }
//}
