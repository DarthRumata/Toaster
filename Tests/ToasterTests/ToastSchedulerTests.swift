//
//  ToastSchedulerTests.swift
//  ToasterTests
//
//  Created by Stas Kirichok on 23.06.2023.
//

import XCTest
@testable import Toaster
import Combine
import SwiftUI

final class ToastSchedulerTests: XCTestCase {
    private var scheduler = ToastScheduler()
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        scheduler = ToastScheduler()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func testCurrentTestIsNilOnStart() throws {
        XCTAssertNil(scheduler.currentToast)
    }

    func testAddingPredefinedToast() throws {
        let expectation = expectation(description: "Toast should be removed after 1 second")

        var counter = 0
        scheduler.$currentToast
            .sink { wrapper in
                switch counter {
                case 1:
                    if case .predefinedView(let toast) = wrapper {
                        XCTAssertEqual(toast, TestConstants.predefinedToast)
                    } else {
                        XCTFail("Toast wasn't appeared")
                    }
                case 2:
                    if wrapper == nil {
                        expectation.fulfill()
                    }
                default:
                    break
                }

                counter += 1
            }
            .store(in: &cancellables)

        scheduler.present(TestConstants.predefinedToast)

        wait(for: [expectation], timeout: TestConstants.oneSecondDelay + TestConstants.tolerance)
    }

    func testAddingCustomToast() throws {
        let expectation = expectation(description: "Toast should be removed after 2 second")

        var counter = 0
        scheduler.$currentToast
            .sink { wrapper in
                switch counter {
                case 1:
                    if case .customView(let customToast) = wrapper {
                        XCTAssertEqual(customToast.dismissDelay, TestConstants.twoSecondsDelay)
                    } else {
                        XCTFail("Toast wasn't appeared")
                    }
                case 2:
                    if wrapper == nil {
                        expectation.fulfill()
                    }
                default:
                    break
                }

                counter += 1
            }
            .store(in: &cancellables)

        scheduler.present(EmptyView(), dismissDelay: TestConstants.twoSecondsDelay)

        wait(for: [expectation], timeout: TestConstants.twoSecondsDelay + TestConstants.tolerance)
    }
}
