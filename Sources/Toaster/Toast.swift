//
//  Toast.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

public enum ToastStyle {
    case error
    case success
    case warning
}

public struct Toast: Equatable {
    let title: String
    let message: String?
    let style: ToastStyle
    let duration: Double
    
    public init(title: String? = nil, message: String?, style: ToastStyle, duration: Double = 4) {
        self.title = title ?? style.title
        self.message = message
        self.style = style
        self.duration = duration
    }
    
    @available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *)
    public init(title: String? = nil, message: String?, style: ToastStyle, duration: Duration = .seconds(4)) {
        self.title = title ?? style.title
        self.message = message
        self.style = style
        self.duration = duration.inSeconds
    }
}

@available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *)
private extension Duration {
    var inSeconds: Double {
        return Double(components.seconds) + Double(components.attoseconds) * 1e-18
    }
}
