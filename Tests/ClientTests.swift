//
//  ClientTests.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/5/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo
import OHHTTPStubs
import ReactiveCocoa
import Result
import Tentacle
import XCTest

public func == <T: Equatable, Error: Equatable> (left: Result<[T], Error>, right: Result<[T], Error>) -> Bool {
    if let left = left.value, right = right.value {
        return left == right
    } else if let left = left.error, right = right.error {
        return left == right
    }
    return false
}

func ExpectResult<O: Equatable>(producer: SignalProducer<O, Client.Error>, _ result: Result<[O], Client.Error>, file: String = __FILE__, line: UInt = __LINE__) {
    let actual = producer.collect().single()!
    let message: String
    switch result {
    case let .Success(value):
        message = "\(actual) is not equal to \(value)"
    case let .Failure(error):
        message = "\(actual) is not equal to \(error)"
    }
    XCTAssertTrue(actual == result, message, file: file, line: line)
}

func ExpectError<O: Equatable>(producer: SignalProducer<O, Client.Error>, _ error: Client.Error, file: String = __FILE__, line: UInt = __LINE__) {
    ExpectResult(producer, .Failure(error), file: file, line: line)
}

func ExpectValues<O: Equatable>(producer: SignalProducer<O, Client.Error>, _ values: O..., file: String = __FILE__, line: UInt = __LINE__) {
    ExpectResult(producer, .Success(values), file: file, line: line)
}


class ClientTests: XCTestCase {
    private let client = Client(.DotCom)
    
    override func setUp() {
        OHHTTPStubs
            .stubRequestsPassingTest({ request in
                return Fixture.fixtureForURL(request.URL!) != nil
            }, withStubResponse: { request -> OHHTTPStubsResponse in
                let fixture = Fixture.fixtureForURL(request.URL!)!
                let response = fixture.response
                return OHHTTPStubsResponse(fileURL: fixture.dataFileURL, statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
            })
    }
    
    func testReleaseForTagInRepository() {
        let fixture = Fixture.Release.Carthage0_15
        ExpectValues(
            client.releaseForTag(fixture.tag, inRepository: fixture.repository),
            fixture.decode()!
        )
    }
    
    func testReleaseForTagInRepositoryNonExistent() {
        let fixture = Fixture.Release.Nonexistent
        ExpectError(
            client.releaseForTag(fixture.tag, inRepository: fixture.repository),
            .DoesNotExist
        )
    }
    
    func testReleaseForTagInRepositoryTagOnly() {
        let fixture = Fixture.Release.TagOnly
        ExpectError(
            client.releaseForTag(fixture.tag, inRepository: fixture.repository),
            .DoesNotExist
        )
    }
}
