//
//  View+Form.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import SwiftUI
import SwiftUIToolbox

public struct FormViewModifier: ViewModifier {
    @ObservedObject var observer: KeyboardObserver
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Button(action: {}, label: { Text("") })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.01))
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
            }
            
            content
                .observeKeyboard(keyboardHeight: observer.keyboardHeight, keyboardAnimationDuration: observer.keyboardAnimationDuration)
        }
    }
}

extension View {
    public func form(observer: KeyboardObserver) -> some View {
        ModifiedContent(content: self, modifier: FormViewModifier(observer: observer))
    }
}

