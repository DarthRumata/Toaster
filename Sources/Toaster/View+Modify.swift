//
//  View+Modify.swift
//  Toaster
//
//  Created by Stas Kirichok on 19.06.2023.
//

import SwiftUI

extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
