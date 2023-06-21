//
//  Toast.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import Foundation

public enum ToastStyle {
    case error
    case success
    case warning
}

public struct Toast: Equatable {
    let title: String
    let message: String?
    let style: ToastStyle
    let dismissDelay: TimeInterval
    
    @available(iOS, obsoleted: 16.0, message: "Please use a modern API")
    @available(macOS, obsoleted: 13.0, message: "Please use a modern API")
    @available(watchOS, obsoleted: 9.0, message: "Please use a modern API")
    @available(tvOS, obsoleted: 16.0, message: "Please use a modern API")
    public init(title: String? = nil, message: String?, style: ToastStyle, dismissDelay: TimeInterval = 4) {
        self.title = title ?? style.title
        self.message = message
        self.style = style
        self.dismissDelay = dismissDelay
    }
    
    @available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *)
    public init(title: String? = nil, message: String?, style: ToastStyle, dismissDelay: Duration = .seconds(4)) {
        self.title = title ?? style.title
        self.message = message
        self.style = style
        self.dismissDelay = dismissDelay.inSeconds
    }
}

@available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *)
private extension Duration {
    var inSeconds: TimeInterval {
        return TimeInterval(components.seconds) + Double(components.attoseconds) * 1e-18
    }
}
