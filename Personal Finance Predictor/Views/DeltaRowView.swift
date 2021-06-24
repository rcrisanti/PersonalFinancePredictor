//
//  DeltaRowView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct DeltaRowView: View {
    var name: String
    var value: Double
    var dates: [Date]
    var dateRepetitionName: String
    
    var specifier: String {
        if value >= 0 {
            return "$%.2f"
        } else {
            return "($%.2f)"
        }
    }
    
    var datesString: String {
        let dateStrings = dates.sorted().map { dateFormatter.string(from: $0) }
        return dateStrings.joined(separator: ", ")
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                Text("\(abs(value), specifier: specifier)")
            }
            
            Text("\(dateRepetitionName.capitalized)\(dates.count > 0 ? ": " : "")\(datesString)")
                .font(.caption)
        }
        .lineLimit(1)
    }
}

struct DeltaRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaRowView(name: "My Delta", value: 124.1, dates: [Date(), Date(timeInterval: 12321, since: Date())], dateRepetitionName: "Custom")
    }
}
