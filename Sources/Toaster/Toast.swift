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
    let duration: Duration
    
    public init(title: String? = nil, message: String?, style: ToastStyle, duration: Duration = .seconds(4)) {
        self.title = title ?? style.title
        self.message = message
        self.style = style
        self.duration = duration
    }
}
