//
//  AladhanAPIEndpointTests.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import XCTest
import SalahTimes

struct AladhanAPIEndpoint {
    let path: String
    
    static func timingsByCity(on date: Date) -> AladhanAPIEndpoint {
        return AladhanAPIEndpoint(path: "/v1/timingsByCity/\(dateFormattedForAPIRequest(date))")
    }
    
    static func dateFormattedForAPIRequest(_ date: Date) -> String {
        let dateFormatter = DateFormatter.readableDateFormatterForAladhanAPI
        
        return dateFormatter.string(from: date)
    }
    
}

private extension DateFormatter {
    static let readableDateFormatterForAladhanAPI: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter
    }()
}

class AladhanAPIEndpointTests: XCTestCase {
    
    func test_timingsByCity_pathIsCorrectForDate() {
        let date = Date()
        let sut = AladhanAPIEndpoint.timingsByCity(on: date)
        let expectedPath = "/v1/timingsByCity/\(AladhanAPIEndpoint.dateFormattedForAPIRequest(date))"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
}
