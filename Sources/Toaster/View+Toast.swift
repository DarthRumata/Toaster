//
//  File.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

private let globalScheduler = BindingToastScheduler()

public typealias OptionsCallback = (ToastOptions) -> ToastOptions

public extension View {
    func toastView(toast: Binding<Toast?>, options: @escaping OptionsCallback = { $0 }) -> some View {
        let isPresented = Binding {
            return toast.wrappedValue != nil
        } set: { isPresented in
            if !isPresented {
                toast.wrappedValue = nil
            }
        }

        globalScheduler.update(binding: isPresented)
        
        return modifier(ToastModifier(scheduler: globalScheduler, options: options(ToastOptions())))
            .onChange(of: toast.wrappedValue, perform: { toast in
                if let toast = toast {
                    globalScheduler.present(toast)
                }
            })
    }
    
    func toastView(isPresented: Binding<Bool>, @ViewBuilder view: @escaping () -> some View, dismissDelay: TimeInterval = ToastAnimationDefaultProperties.dismissDelay, options: @escaping OptionsCallback = { $0 }) -> some View {
        globalScheduler.update(binding: isPresented)
        
        return modifier(ToastModifier(scheduler: globalScheduler, options: options(ToastOptions())))
            .onChange(of: isPresented.wrappedValue, perform: { isPresented in
                if isPresented {
                    globalScheduler.present(view(), dismissDelay: dismissDelay)
                }
            })
    }
    
    func toastView(scheduler: ToastScheduler, options: @escaping OptionsCallback = { $0 }) -> some View {
        modifier(ToastModifier(scheduler: scheduler, options: options(ToastOptions())))
    }
}
