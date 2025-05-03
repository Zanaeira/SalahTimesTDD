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
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (salahTimesLoader: SalahTimesLoader, endpoint: Endpoint) {
        let date = Date(timeIntervalSince1970: 1628143200)
        let address = "London, UK"
        let endpoint: Endpoint = AladhanAPIEndpoint.timingsByAddress(address, on: date, madhhabForAsr: .shafii)
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let salahTimesLoader = SalahTimesLoader(client: client)
        trackForMemoryLeaks(salahTimesLoader, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (salahTimesLoader, endpoint)
    }
    
    private func getSalahTimesLoadingResult() -> TimesLoader.Result? {
        let (salahTimesLoader, endpoint) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: TimesLoader.Result?
        salahTimesLoader.load(from: endpoint) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
}
