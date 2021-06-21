//
//  CurrencyField.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import SwiftUI

struct CurrencyField: View {
    // https://stackoverflow.com/a/65783711
    
    @Binding var value: Double
    
    @StateObject private var bindingManager = TextBindingManager(amount: 0)
    var double: Double {
        bindingManager.text.double / pow(10, Double(Formatter.currency.maximumFractionDigits))
    }
    let maximum: Double = 999_999_999_999.99
    @State private var lastValue: String = ""
    @State private var locale: Locale = .current {
        didSet {
            Formatter.currency.locale = locale
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(bindingManager.text, text: $bindingManager.text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)  // this will keep the text aligned to the right
                .onChange(of: bindingManager.text) { string in
                    if string.double > maximum {
                        bindingManager.text = lastValue
                    } else {
                        bindingManager.text = double.currency
                        lastValue = bindingManager.text
                        value = bindingManager.text.double
                    }
                    return
                }
        }
        .padding()
        .onAppear {
            Formatter.currency.locale = locale
            bindingManager.text = value.currency
        }
    }
}

struct CurrencyField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyField(value: .constant(34.5))
    }
}
