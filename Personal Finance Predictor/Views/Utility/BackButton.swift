//
//  BackButton.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/23/21.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}

struct BackButtonModifier: ViewModifier {
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(action: action)
                }
            }
    }
}

extension View {
    func backButton(action: @escaping () -> Void) -> some View {
        self.modifier(BackButtonModifier(action: action))
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Hello, world!")
                .backButton {
                    PersistenceController.shared.save()
                }
        }
    }
}
