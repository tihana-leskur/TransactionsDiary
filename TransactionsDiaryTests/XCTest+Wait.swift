//
//  XCTestCase+Wait.swift
//  TransactionsDiaryTests
//
//  Created by Tihana Leskur on 12.6.24..
//

import XCTest
import Combine

enum XCTestCasePublisherError: Error {
    case receivedValueButNoneExpected
}

extension XCTestCase {
    func wait(
        for timeout: CGFloat = 1,
        completion: () -> Void
    ) {
        let expectation = expectation(description: "Test after delay")
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        if result == XCTWaiter.Result.timedOut {
            completion()
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        line: UInt = #line,
        executionAction: (() -> Void)? = nil
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )

        executionAction?()

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }

    func awaitForFailure<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        line: UInt = #line,
        executionAction: (() -> Void)? = nil
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                    expectation.fulfill()
                case .finished:
                    break
                }
            },
            receiveValue: { _ in }
        )

        executionAction?()

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }

    func awaitForNoUpdates<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line,
        executionAction: (() -> Void)? = nil
    ) throws {
        var result: Result<Void, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher
            .timeout(.seconds(Int(timeout)), scheduler: RunLoop.current)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { _ in
                result = .failure(XCTestCasePublisherError.receivedValueButNoneExpected)
                expectation.fulfill()
            }

        executionAction?()

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        switch result {
            case .failure(let error):
                throw error
            default:
                return
        }
    }
}
