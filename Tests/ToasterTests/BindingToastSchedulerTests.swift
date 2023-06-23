//
//  BindingToastSchedulerTests.swift
//  ToasterTests
//
//  Created by Stas Kirichok on 23.06.2023.
//

import XCTest
@testable import Toaster
import Combine
import SwiftUI

final class BindingToastSchedulerTests: XCTestCase {
    private var scheduler = BindingToastScheduler()
    private var storageBool = false
    private lazy var isPresented = Binding<Bool> {
        self.storageBool
    } set: { newValue in
        self.storageBool = newValue
    }

    private var cancellables = Set<AnyCancellable>()

    private let predefinedToast = Toast(message: "Predefined", style: .error, dismissDelay: TestConstants.oneSecondDelay)

    override func setUpWithError() throws {
        scheduler = BindingToastScheduler()
    }

    override func tearDownWithError() throws {
        isPresented.wrappedValue = false
        cancellables.removeAll()
    }

    func testBindingIsReset() throws {
        let expectation = expectation(description: "Toast should be removed after 4 second")

        scheduler.update(binding: isPresented)
        scheduler.present(predefinedToast)

        var counter = 0
        scheduler.$currentToast
            .sink { wrapper in
                switch counter {
                case 0:
                    XCTAssertNil(wrapper)
                case 1:
                    if case .predefinedView(let toast) = wrapper {
                        XCTAssertEqual(toast, self.predefinedToast)
                    } else {
                        XCTFail("Toast wasn't appeared")
                    }
                case 2:
                    if wrapper == nil {
                        XCTAssertFalse(self.isPresented.wrappedValue)
                        expectation.fulfill()
                    }
                default:
                    break
                }

                counter += 1
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: TestConstants.oneSecondDelay + TestConstants.tolerance)
    }

}
