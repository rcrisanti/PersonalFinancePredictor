//
//  BottomSheet.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/20/21.
//

import SwiftUI

struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let sheetContent: SheetContent
    
    init(isPresented: Binding<Bool>, isOpen: Binding<Bool>, maxHeight: CGFloat = 600, @ViewBuilder content: () -> SheetContent) {
        _isPresented = isPresented
        _isOpen = isOpen
        self.maxHeight = maxHeight
        self.sheetContent = content()
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                BottomSheetView(isOpen: $isOpen, maxHeight: maxHeight) {
                    sheetContent
                }
            }
        }
    }
}

extension View {
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, isOpen: Binding<Bool>, maxHeight: CGFloat = 600, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(BottomSheet(isPresented: isPresented, isOpen: isOpen, maxHeight: maxHeight) {
            content()
        })
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world")
            .bottomSheet(isPresented: .constant(true), isOpen: .constant(false)) {
                Text("Bottom sheet content")
            }
    }
}
