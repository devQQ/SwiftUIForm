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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        scrollView.delegate = context.coordinator
        
        let size = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: size.width, height: size.height)
        
        let vc = UIHostingController(rootView: content())
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(vc.view)
        
        return scrollView
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.isScrollEnabled = keyboardHeight > 0
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        uiView.contentInset = insets
        uiView.scrollIndicatorInsets = insets
        
        guard activeFrame != context.coordinator.animatedFrame,
            !context.coordinator.isAnimating else {
                return
        }
        
        context.coordinator.animatedFrame = activeFrame
        
        if activeFrame.origin.y > 0 {
            var globalFrame = UIScreen.main.bounds
            globalFrame.size.height -= keyboardHeight
            
            guard !globalFrame.contains(activeFrame.origin) else {
                return
            }
            
            context.coordinator.isAnimating = true
            uiView.scrollRectToVisible(activeFrame, animated: true)
        } else {
            uiView.setContentOffset(.zero, animated: true)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}