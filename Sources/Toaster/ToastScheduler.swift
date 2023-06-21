//
//  ToastScheduler.swift
//  Toaster
//
//  Created by Stas Kirichok on 19.06.2023.
//

import SwiftUI
import DequeModule

public class ToastScheduler: ObservableObject {
    @Published private(set) var currentToast: ToastWrapper?
    private var toastQueue = Deque<ToastWrapper>()
    private var dismissTask: Task<(), Never>?
    
    public init() {}
    
    public func present<T: View>(_ view: T, dismissDelay: TimeInterval) {
        let toast = CustomToast(view: AnyView(view), dismissDelay: dismissDelay)
        Task {
            await presentToast(.customView(toast))
        }
    }
    
    public func present(_ toast: Toast) {
        Task {
            await presentToast(.predefinedView(toast))
        }
    }
    
    @MainActor
    private func presentToast(_ toast: ToastWrapper) {
        toastQueue.append(toast)
        
        if currentToast == nil {
            presentNextToast()
        }
    }
    
    @MainActor
    private func presentNextToast() {
        guard let nextToast = toastQueue.popFirst() else { return }
        
        scheduleDismiss(for: nextToast)
        currentToast = nextToast
    }
    
    private func scheduleDismiss(for toast: ToastWrapper) {
        dismissTask?.cancel()
        
        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(toast.dismissDelay * Double(1_000_000_000)))
            await dismissCurrentToast()
        }
    }
    
    @MainActor
    private func dismissCurrentToast() {
        withAnimation {
            currentToast = nil
        }
        
        dismissTask?.cancel()
        dismissTask = nil
        Task {
            try? await Task.sleep(nanoseconds: UInt64(3e+8))
            presentNextToast()
        }
    }
}

// MARK: - ToastWrapper

enum ToastWrapper: Equatable {
    case predefinedView(Toast)
    case customView(CustomToast)
    
    static func == (lhs: ToastWrapper, rhs: ToastWrapper) -> Bool {
        switch (lhs, rhs) {
        case (.predefinedView(let leftToast), .predefinedView(let rightToast)):
            return leftToast == rightToast
        case (.customView(let leftToast), .customView(let rightToast)):
            return leftToast.id == rightToast.id
        default:
            return false
        }
    }
    
    var dismissDelay: TimeInterval {
        switch self {
        case .predefinedView(let toast):
            return toast.dismissDelay
        case .customView(let customToast):
            return customToast.dismissDelay
        }
    }
}


// MARK: - CustomToast

struct CustomToast: Identifiable {
    let id = UUID()
    let view: AnyView
    let dismissDelay: TimeInterval
    
    init<T: View>(view: T, dismissDelay: TimeInterval) {
        self.view = AnyView(view)
        self.dismissDelay = dismissDelay
    }
}
