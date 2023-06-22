//
//  ToastOptions.swift
//  Toaster
//
//  Created by Stas Kirichok on 22.06.2023.
//

import SwiftUI

public enum ToastTransition {
    case move
    case push
    case crossDissolve
    case scale
    case custom(AnyTransition)
}

public enum ToastPosition {
    case top
    case bottom
}

public class ToastOptions {
    var customOffset: CGFloat?
    var transition: ToastTransition = .move
    var position: ToastPosition = .bottom
    
    init() {}
    
    public func customOffset(_ offset: CGFloat) -> ToastOptions {
        customOffset = offset
        return self
    }
    
    public func transition(_ transition: ToastTransition) -> ToastOptions {
        self.transition = transition
        return self
    }
    
    public func position(_ position: ToastPosition) -> ToastOptions {
        self.position = position
        return self
    }
    
    var viewTransition: AnyTransition {
        switch transition {
        case .move:
            return .move(edge: position == .bottom ? .bottom : .top).combined(with: .opacity)
            
        case .push:
            return
                .asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .trailing)
                )
                .combined(with: .opacity)
            
        case .crossDissolve:
            return .opacity
            
        case .scale:
            return .scale
            
        case .custom(let customTransition):
            return customTransition
        }
    }
    
    var offset: CGFloat {
        if let customOffset = customOffset {
            return customOffset
        }
        
        return position == .bottom ? ToastAnimationDefaultProperties.iosBottomOffset : ToastAnimationDefaultProperties.iosTopOffset
    }
}
