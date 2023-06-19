import XCTest
@testable import Toaster

private enum Constants {
    static let customTitle = "Alert"
    static let message = "Hi"
}

final class ToastTests: XCTestCase {
    @available(tvOS 16.0, iOS 16.0, macOS 13.0, watchOS 8.0, *)
    func testInitWithDelayDuration() throws {
        let toast = Toast(message: Constants.message, style: .error, dismissDelay: Duration.milliseconds(2399))
        XCTAssertEqual(toast.dismissDelay, 2.399, accuracy: 0.0001, "Incorrect delay conversion")
    }
    
    #if compiler(<5.7)
    func testInitWithDelayDouble() throws {
        let toast = Toast(message: Constants.message, style: .error, dismissDelay: 2.399)
        XCTAssertEqual(toast.dismissDelay, 2.399, accuracy: 0.0001, "Incorrect custom delay")
    }
    #endif
    
    func testDefaultDelay() throws {
        let toast = Toast(message: Constants.message, style: .error)
        XCTAssertEqual(toast.dismissDelay, 4, accuracy: 0.0001, "Incorrect default delay")
    }
    
    func testErrorToastWithoutTitle() throws {
        let toast = Toast(message: Constants.message, style: .error)
        XCTAssertEqual(toast.title, "Error")
    }
    
    func testSuccessToastWithoutTitle() throws {
        let toast = Toast(message: Constants.message, style: .success)
        XCTAssertEqual(toast.title, "Success")
    }
    
    func testWarningToastWithoutTitle() throws {
        let toast = Toast(message: Constants.message, style: .warning)
        XCTAssertEqual(toast.title, "Warning")
    }
    
    func testErrorToastWithTitle() throws {
        let toast = Toast(title: Constants.customTitle, message: Constants.message, style: .error)
        XCTAssertEqual(toast.title, Constants.customTitle)
    }
    
    func testToastHasCorrectMessage() throws {
        let toast = Toast(message: Constants.message, style: .error)
        XCTAssertEqual(toast.message, Constants.message)
    }
}
