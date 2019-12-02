//
//  NUMoviesDBDataWorkerTests.swift
//  NEUGELBTaskTests
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import XCTest
@testable import NEUGELBTask

class NUMoviesDBDataWorkerTests: XCTestCase {

    var dataWorker:NUMoviesDBDataWorker?

    override func setUp() {
        super.setUp()
        dataWorker = NUMoviesDBDataWorker()
    }

    override func tearDown() {
        dataWorker = nil
        super.tearDown()
    }

    func testNowPlaying() {
        let expectationObject = expectation(description: "get now playing valid test")
        dataWorker?.getNowPlaying(page: 1, completion: { (response, error) in
            expectationObject.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertTrue(response!.totalResults > 0)
        })
        wait(for: [expectationObject], timeout: 2.0)
    }

    func testNowPlayingInvalidToken() {
        let expectationObject = expectation(description: "get now playing InValid test")
        dataWorker?.token = "Invalid"
        dataWorker?.getNowPlaying(page: 1, completion: { (response, error) in
            expectationObject.fulfill()
            XCTAssertNotNil(error)
        })
        wait(for: [expectationObject], timeout: 2.0)
    }

    func testNowPlayingPageIDToken() {
        let expectationObject = expectation(description: "get now playing InValid page Id test")
        dataWorker?.getNowPlaying(page: -1, completion: { (response, error) in
            expectationObject.fulfill()
            XCTAssertNotNil(error)
        })
        wait(for: [expectationObject], timeout: 2.0)
    }

    func testSearchMovie() {
        let expectationObject = expectation(description: "search movie")
        let movie = "Ford"
        dataWorker?.searchMovie(keyword: movie, completion: { (response, error) in
            expectationObject.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertTrue(response!.totalResults > 0)
        })
        wait(for: [expectationObject], timeout: 3.0)
    }

}
