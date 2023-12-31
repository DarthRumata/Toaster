//
//  CustomToastModifier.swift
//  Toaster
//
//  Created by Stas Kirichok on 19.06.2023.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @ObservedObject private var scheduler: ToastScheduler
    private let options: ToastOptions
    
    init(scheduler: ToastScheduler, options: ToastOptions) {
        self.scheduler = scheduler
        self.options = options
    }
    
    func body(content: Content) -> some View {
        let alignment: Alignment = options.position == .bottom ? .bottom : .top
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modify {
                if #available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 15.0, *) {
                    $0.overlay(alignment: alignment) {
                        overlay(toastView: toastView)
                    }
                } else {
                    // Fallback on earlier versions
                    $0.overlay(overlay(toastView: toastView), alignment: alignment)
                }
            }
    }
    
    @ViewBuilder private func overlay(toastView: () -> some View) -> some View {
        ZStack {
            toastView()
                .transition(options.viewTransition)
                .offset(y: options.offset)
        }
        .animation(.easeInOut(duration: ToastDefaultProperties.transitionDuration), value: scheduler.currentToast)
    }
    
    @ViewBuilder private func toastView() -> some View {
        if let toastWrapper = scheduler.currentToast {
            switch toastWrapper {
            case .predefinedView(let toast):
                AnyView(ToastView(toast: toast))
            case .customView(let toast):
                toast.view
            }
        }
    }
}
