//
//  File.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

private let globalScheduler = BindingToastScheduler()

public extension View {
    func toastView(toast: Binding<Toast?>, options: @escaping (ToastOptions) -> ToastOptions = { $0 }) -> some View {
        let isPresenting = Binding {
            return toast.wrappedValue != nil
        } set: { isPresenting in
            if !isPresenting {
                toast.wrappedValue = nil
            }
        }
        
        globalScheduler.update(binding: isPresenting)
        return modifier(ToastModifier(scheduler: globalScheduler, options: options(ToastOptions())))
            .onChange(of: toast.wrappedValue, perform: { toast in
                if let toast = toast {
                    globalScheduler.present(toast)
                }
            })
    }
    
    func toastView(isPresented: Binding<Bool>, @ViewBuilder view: @escaping () -> some View, dismissDelay: TimeInterval = ToastAnimationDefaultProperties.dismissDelay, options: @escaping (ToastOptions) -> ToastOptions = { $0 }) -> some View {
        globalScheduler.update(binding: isPresented)
        return modifier(ToastModifier(scheduler: globalScheduler, options: options(ToastOptions())))
            .onChange(of: isPresented.wrappedValue, perform: { isPresented in
                if isPresented {
                    globalScheduler.present(view(), dismissDelay: dismissDelay)
                }
            })
    }
    
    func toastView(scheduler: ToastScheduler, options: @escaping (ToastOptions) -> ToastOptions = { $0 }) -> some View {
        modifier(ToastModifier(scheduler: scheduler, options: options(ToastOptions())))
    }
}
