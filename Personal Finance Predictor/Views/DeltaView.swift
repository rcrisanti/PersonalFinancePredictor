//
//  DeltaView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/21/21.
//

import SwiftUI

struct DeltaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Text("Delta bottom sheet content")
                .navigationBarTitle("New Delta")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
        }
    }
}

struct DeltaView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaView()
    }
}
