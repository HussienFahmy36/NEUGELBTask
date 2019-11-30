//
//  NetworkLayerTests.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 30/11/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import XCTest
@testable import NEUGELBTask

class NetworkLayerTests: XCTestCase {
    var networkLayer: NetworkLayer?

    override func setUp() {
        super.setUp()
        networkLayer = NetworkLayer()
    }

    override func tearDown() {
        networkLayer = nil
        super.tearDown()
    }
    func testsLoadDataFromURLAsync() {
        let urlString = "https://reqres.in/api/users?page=2"
        guard let sampleURL = URL.init(string: urlString) else {
            XCTFail("URL not valid")
            return
        }
        let expectation = self.expectation(description: "Loading data from url valid async")
        networkLayer?.downloadAsync(from: sampleURL) { (data, error) in
            expectation.fulfill()
            XCTAssertNotNil(data, "Loaded data is not nil")
            XCTAssertTrue(!data!.isEmpty, "Loaded sucesfully from sample url: \(urlString)")

        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testsLoadDataFromURLAsyncInvalid() {
        let urlString = "abc"
        guard let sampleURL = URL.init(string: urlString) else {
            XCTFail("URL not valid")
            return
        }
        let expectation = self.expectation(description: "Loading data from url InValid async")
        networkLayer?.downloadAsync(from: sampleURL) { (data, error) in
            expectation.fulfill()
            XCTAssertNil(data)
            XCTAssertEqual(error, .urlInvalid)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLoadDataFromURLAsyncURLNotFound() {
        let urlString = "http://google.com/abc"
        guard let sampleURL = URL.init(string: urlString) else {
            XCTFail("URL not valid")
            return
        }
        let expectation = self.expectation(description: "Loading data from url noResponse async")
        networkLayer?.downloadAsync(from: sampleURL) { (data, error) in
            expectation.fulfill()
            XCTAssertNil(data)
            XCTAssertEqual(error, .urlNotFound)
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
