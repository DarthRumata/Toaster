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
            .overlay(alignment: .bottom) {
                ZStack {
                    toastView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .offset(y: -32)
                }
                .animation(.easeInOut(duration: 0.3), value: toast)
            }
            .onChange(of: toast) { value in
                if value != nil {
                    scheduleDismiss()
                }
            }
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
            try? await Task.sleep(for: toast.duration)
            dismissToast()
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        task?.cancel()
        task = nil
    }
}
