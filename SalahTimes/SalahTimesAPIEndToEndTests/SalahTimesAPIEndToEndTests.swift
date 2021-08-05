//
//  SalahTimesAPIEndToEndTests.swift
//  SalahTimesAPIEndToEndTests
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import XCTest
import SalahTimes

class SalahTimesAPIEndToEndTests: XCTestCase {
    
    func test_endToEndAladhanAPIGETSalahTimes_matchesTestSalahTimes() {
        let receivedResult = getSalahTimesLoadingResult()
        let (expectedSalahTimes, _) = salahTimesModelAndDataFor5thAug2021LondonUK()
        
        switch receivedResult {
        case let .success(salahTimes):
            XCTAssertEqual(salahTimes, expectedSalahTimes)
        case let .failure(error):
            XCTFail("Expected successful salah times, got \(error) instead")
        default:
            XCTFail("Expected successful salah times result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (salahTimesLoader: SalahTimesLoader, endpoint: Endpoint) {
        let endpoint = EndpointSpy(urlString: "http://api.aladhan.com/v1/timingsByCity/05-08-2021?city=London&country=UK")
        let client = URLSessionHTTPClient()
        let salahTimesLoader = SalahTimesLoader(client: client)
        trackForMemoryLeaks(salahTimesLoader)
        trackForMemoryLeaks(client)
        
        return (salahTimesLoader, endpoint)
    }
    
    private func getSalahTimesLoadingResult() -> SalahTimesLoader.Result? {
        let (salahTimesLoader, endpoint) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: SalahTimesLoader.Result?
        salahTimesLoader.loadTimes(from: endpoint) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
    private struct EndpointSpy: Endpoint {
        let path: String = ""
        let queryItems: [URLQueryItem] = []
        
        private let testURLString: String
        
        var url: URL {
            return URL(string: testURLString)!
        }
        
        init(urlString: String) {
            testURLString = urlString
        }
    }
    
}
