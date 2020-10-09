//
//  FormScrollView.swift
//  
//
//  Created by Quang Trang on 8/3/20.
//

import SwiftUI

public struct FormScrollView<Content: View>: UIViewRepresentable {
    public class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: FormScrollView
        var isAnimating: Bool = false
        var animatedFrame: CGRect = .zero
        var cacheActiveFrame: CGRect = .zero
        
        init(_ parent: FormScrollView) {
            self.parent = parent
        }

        public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            isAnimating = false
        }
    }
    
    @Binding var keyboardHeight: CGFloat
    @Binding var activeFrame: CGRect
    public let content: () -> Content
    
    public init(keyboardHeight: Binding<CGFloat>, activeFrame: Binding<CGRect>,  @ViewBuilder _ content: @escaping () -> Content) {
        self._keyboardHeight = keyboardHeight
        self._activeFrame = activeFrame
        self.content = content
    }
    
    public func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        scrollView.delegate = context.coordinator
        
        let size = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: size.width, height: size.height)
        
        let vc = UIHostingController(rootView: content())
        vc.view.backgroundColor = .clear
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(vc.view)
        
        return scrollView
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        uiView.contentInset = insets
        uiView.scrollIndicatorInsets = insets

        context.coordinator.animatedFrame = activeFrame
        
        if activeFrame.origin.y > 0 {
            var globalFrame = UIScreen.main.bounds
            //64 pixels for buffer
            //44 pixels for typical textfield height
            globalFrame.size.height -= (keyboardHeight + 64.0 + 44.0)
            
            //give some buffer for the textfield just in case there is an input accessory view
            var visibleFrame = activeFrame
            visibleFrame.origin.y -= 44.0
            
            guard !globalFrame.contains(activeFrame.origin) &&
                    context.coordinator.cacheActiveFrame != activeFrame else {
                return
            }
            
            context.coordinator.isAnimating = true
            uiView.scrollRectToVisible(visibleFrame, animated: true)
            context.coordinator.cacheActiveFrame = activeFrame
        } else {
            context.coordinator.cacheActiveFrame = .zero
            uiView.setContentOffset(.zero, animated: true)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
