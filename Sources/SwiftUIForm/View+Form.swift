//
//  View+Form.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import SwiftUI
import SwiftUIToolbox

public struct FormKeyboardObserverViewModifier: ViewModifier {
    @Binding var keyboardHeight: CGFloat
    let keyboardAnimationDuration: Double
    @Binding var activeFrame: CGRect
    
    public func body(content: Content) -> some View {
        FormScrollView(keyboardHeight: self.$keyboardHeight, activeFrame: $activeFrame) {
            content
                .edgesIgnoringSafeArea(self.keyboardHeight > 0 ? .bottom : [])
                .animation(.easeInOut(duration: self.keyboardAnimationDuration))
        }
    }
}

extension View {
    public func observeFormKeyboard(keyboardHeight: Binding<CGFloat>, keyboardAnimationDuration: Double, activeFrame: Binding<CGRect>) -> some View {
        return ModifiedContent(content: self, modifier: FormKeyboardObserverViewModifier(keyboardHeight: keyboardHeight, keyboardAnimationDuration: keyboardAnimationDuration, activeFrame: activeFrame))
    }
}

public struct FormViewModifier: ViewModifier {
    @ObservedObject var observer: KeyboardObserver
    var activeFrame: Binding<CGRect>
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Button(action: {}, label: { Text("") })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.01))
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
            
            content
        }
        .observeFormKeyboard(keyboardHeight: $observer.keyboardHeight, keyboardAnimationDuration: observer.keyboardAnimationDuration, activeFrame: activeFrame)
    }
}
extension View {
    public func form(observer: KeyboardObserver, activeFrame: Binding<CGRect>) -> some View {
        ModifiedContent(content: self, modifier: FormViewModifier(observer: observer, activeFrame: activeFrame))
    }
}

