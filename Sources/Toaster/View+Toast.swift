//
//  File.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

public extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
