//
//  ToastModifier.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var task: Task<(), Never>?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modify {
                if #available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 15.0, *) {
                    $0.overlay(alignment: .bottom) {
                        overlay(toastView: toastView)
                    }
                } else {
                    // Fallback on earlier versions
                    $0.overlay(overlay(toastView: toastView), alignment: .bottom)
                }
            }
            .onChange(of: toast) { value in
                if value != nil {
                    scheduleDismiss()
                }
            }
    }
    
    @ViewBuilder private func overlay(toastView: () -> some View) -> some View {
        ZStack {
            toastView()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .offset(y: -32)
        }
        .animation(.easeInOut(duration: 0.3), value: toast)
    }
    
    @ViewBuilder private func toastView() -> some View {
        if let toast = toast {
            ToastView(toast: toast)
        }
    }
    
    private func scheduleDismiss() {
        guard let toast = toast else { return }
        
        task?.cancel()
        
        task = Task {
            try? await Task.sleep(nanoseconds: UInt64(toast.dismissDelay * Double(1_000_000_000)))
            await dismissToast()
        }
    }
    
    @MainActor
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        task?.cancel()
        task = nil
    }
}

private extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
