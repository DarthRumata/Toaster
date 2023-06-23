//
//  TestConstants.swift
//  ToasterTests
//
//  Created by Stas Kirichok on 23.06.2023.
//

import Foundation
import Toaster

enum TestConstants {
    static let oneSecondDelay = TimeInterval(1)
    static let twoSecondsDelay = TimeInterval(2)
    static let tolerance: TimeInterval = 0.2

    static var predefinedToast: Toast {
        Toast(
            message: "Predefined",
            style: .error,
            dismissDelay: TestConstants.oneSecondDelay
        )
    }
}
