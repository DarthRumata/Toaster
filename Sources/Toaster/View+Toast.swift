//
//  File.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

private let globalScheduler = BindingToastScheduler()

public extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        let isPresenting = Binding {
            return toast.wrappedValue != nil
        } set: { isPresenting in
            if !isPresenting {
                toast.wrappedValue = nil
            }
        }
        
        globalScheduler.update(binding: isPresenting)
        return modifier(ToastModifier(scheduler: globalScheduler))
            .onChange(of: toast.wrappedValue, perform: { toast in
                if let toast = toast {
                    globalScheduler.present(toast)
                }
            })
    }
    
    func toastView(isPresented: Binding<Bool>, @ViewBuilder view: @escaping () -> some View, dismissDelay: TimeInterval = ToastAnimationDefaultProperties.dismissDelay) -> some View {
        globalScheduler.update(binding: isPresented)
        return modifier(ToastModifier(scheduler: globalScheduler))
            .onChange(of: isPresented.wrappedValue, perform: { isPresented in
                if isPresented {
                    globalScheduler.present(view(), dismissDelay: dismissDelay)
                }
            })
    }
    
    func toastView(scheduler: ToastScheduler) -> some View {
        modifier(ToastModifier(scheduler: scheduler))
    }
}
