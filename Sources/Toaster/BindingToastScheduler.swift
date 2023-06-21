//
//  BindingToastScheduler.swift
//  Toaster
//
//  Created by Stas Kirichok on 21.06.2023.
//

import SwiftUI
import Combine

class BindingToastScheduler: ToastScheduler {
    @Binding private var isPresenting: Bool
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        _isPresenting = Binding.constant(false)
        
        super.init()
        
        $currentToast
            .sink { [weak self] toast in
                if toast == nil {
                    self?.isPresenting = false
                }
            }
            .store(in: &cancellables)
    }
    
    func update(binding: Binding<Bool>) {
        _isPresenting = binding
    }
}
