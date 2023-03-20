import Foundation
import CleevioLoggerLibrary
import XCTest

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class MyLibraryTests: XCTestCase {
    var mockLoggerService: LoggerServiceMock!
    var logger: CleevioLogger!

    override func setUp() {
        super.setUp()
        
        mockLoggerService = LoggerServiceMock()
        logger = .init(service: mockLoggerService)
    }

    func testLog() {
        let logMessage = "LogMessage"
        
        let expectation = XCTestExpectation(description: "LogClosure is called")
        
        mockLoggerService.logClosure = { log in
            XCTAssertEqual(log.message as? String, logMessage)
            expectation.fulfill()
        }
        
        logger.info(logMessage)
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testLogIsNotCalledWithLowMinimumLevel() async throws {
        let logMessage = "LogMessage"
        
        mockLoggerService.minimalLogLevel = .error
        
        mockLoggerService.logClosure = { log in
            XCTFail("Logger should not be called")
        }
        
        logger.debug(logMessage)
        logger.verbose(logMessage)
        logger.info(logMessage)
        
        try await Task.sleep(nanoseconds: 100_000_000)
    }

    func testUpdateUserInfo() {
        let expectedValue = [
            LogUserInfoKey.userID: "11341",
            .deviceID: "147482",
            .custom(key: "PerfectKey"): "2422"
        ]
        
        let expectation = XCTestExpectation(description: "UpdateUserInfo is called")
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, expectedValue)
            expectation.fulfill()
        }
        
        logger.updateUserInfo(for: expectedValue)
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testUpdateUserInfoForEmptyDictionary() {
        let expectedValue: [LogUserInfoKey: String] = [:]
        let expectation = XCTestExpectation(description: "UpdateUserInfo is called")
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, expectedValue)
            expectation.fulfill()
        }
        
        logger.updateUserInfo(for: expectedValue)
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testUpdateUserInfoSingleKey() {
        let expectedKey = LogUserInfoKey.userID
        let expectedValue = "11341"
        
        let expectation = XCTestExpectation(description: "UpdateUserInfo is called")

        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, [expectedKey: expectedValue])
            expectation.fulfill()
        }
        
        logger.updateUserInfo(for: expectedKey, with: expectedValue)
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testRemoveUserInfo() {
        let expectedKeys = [LogUserInfoKey.deviceID, .email, .custom(key: "Perfect key")]
        let expectation = XCTestExpectation(description: "RemoveUserInfo is called")
        let userInfoExpectation = XCTestExpectation(description: "UserInfo is called")

        mockLoggerService.removeUserInfoClosure = { keys in
            XCTAssertEqual(keys, expectedKeys)
            expectation.fulfill()
        }
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, [:])
            userInfoExpectation.fulfill()
        }
        
        logger.removeUserInfo(for: expectedKeys)
        
        wait(for: [expectation, userInfoExpectation], timeout: 0.1)
    }

    func testRemoveUserInfoForEmptyKeys() {
        let expectedKeys: [LogUserInfoKey] = []
        let expectation = XCTestExpectation(description: "RemoveUserInfo is called")
        let userInfoExpectation = XCTestExpectation(description: "UserInfo is called")

        mockLoggerService.removeUserInfoClosure = { keys in
            XCTAssertEqual(keys, expectedKeys)
            expectation.fulfill()
        }
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, [:])
            userInfoExpectation.fulfill()
        }
        
        logger.removeUserInfo(for: expectedKeys)
        
        wait(for: [expectation, userInfoExpectation], timeout: 0.1)
    }

    func testRemoveUserInfoForSingleKey() {
        let expectedKey = LogUserInfoKey.email
        let expectation = XCTestExpectation(description: "RemoveUserInfo is called")
        let userInfoExpectation = XCTestExpectation(description: "UserInfo is called")

        mockLoggerService.removeUserInfoClosure = { keys in
            XCTAssertEqual(keys, [expectedKey])
            expectation.fulfill()
        }
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            XCTAssertEqual(userInfo, [:])
            userInfoExpectation.fulfill()
        }
        
        logger.removeUserInfo(for: expectedKey)
        
        wait(for: [expectation, userInfoExpectation], timeout: 0.1)
    }

    func testRemoveUserInfoPreservesPreviouslySetUserInfo() {
        let dictionary = [
            LogUserInfoKey.deviceID: "13131",
            .email: "lukas.valenta@cleevio.com",
            .custom(key: "Perfect key"): "42421"
            
        ]
        
        let userInfoExpectation = XCTestExpectation(description: "UserInfo is called")
        let userInfoSecondExpectation = XCTestExpectation(description: "UserInfo is called")

        var userInfoHasBeenCalled = false
        
        mockLoggerService.configureUserInfoClosure = { userInfo in
            if !userInfoHasBeenCalled {
                XCTAssertEqual(userInfo, dictionary)
                userInfoHasBeenCalled = true
                userInfoExpectation.fulfill()
            } else {
                XCTAssertEqual(userInfo.count, 2)
                XCTAssertEqual(userInfo[.deviceID], "13131")
                XCTAssertEqual(userInfo[.custom(key: "Perfect key")], "42421")
                userInfoSecondExpectation.fulfill()
            }
        }
        
        logger.updateUserInfo(for: dictionary)
        
        logger.removeUserInfo(for: .email)
        
        wait(for: [userInfoExpectation, userInfoSecondExpectation], timeout: 0.1)
    }

    // Here just to ensure logger does not crash
    func testEmptyLogger() {
        logger = .init(services: [])
        
        logger.info("Message")
        logger.updateUserInfo(for: .email, with: "kgkfd")
        logger.removeUserInfo(for: .email)
    }
}
