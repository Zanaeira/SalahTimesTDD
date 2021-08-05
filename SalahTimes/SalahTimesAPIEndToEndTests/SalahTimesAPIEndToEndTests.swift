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
        let endpoint = EndpointSpy(urlString: "http://api.aladhan.com/v1/timingsByCity/05-08-2021?city=London&country=UK")
        let client = URLSessionHTTPClient()
        let salahTimesLoader = SalahTimesLoader(client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: SalahTimesLoader.Result?
        salahTimesLoader.loadTimes(from: endpoint) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(salahTimes):
            XCTAssertEqual(salahTimes.fajr, "03:27")
            XCTAssertEqual(salahTimes.sunrise, "05:31")
            XCTAssertEqual(salahTimes.zuhr, "13:07")
            XCTAssertEqual(salahTimes.asr, "17:14")
            XCTAssertEqual(salahTimes.maghrib, "20:42")
            XCTAssertEqual(salahTimes.isha, "22:44")
        case let .failure(error):
            XCTFail("Expected successful salah times, got \(error) instead")
        default:
            XCTFail("Expected successful salah times result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
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
