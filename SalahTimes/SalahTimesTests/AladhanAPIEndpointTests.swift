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
    let queryItems: [URLQueryItem]
    
    static func timingsByLocation(_ location: Location, on date: Date) -> AladhanAPIEndpoint {
        return AladhanAPIEndpoint(path: "/v1/timingsByCity/\(dateFormattedForAPIRequest(date))", queryItems: [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country)
        ])
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
        let sut = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: date)
        let expectedPath = "/v1/timingsByCity/\(AladhanAPIEndpoint.dateFormattedForAPIRequest(date))"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_timingsByCity_queryItemsForCityAndCountryIncluded() {
        let date = Date()
        let location = Location(city: "London", country: "UK")
        let sut = AladhanAPIEndpoint.timingsByLocation(location, on: date)
        
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country)
        ]
        
        XCTAssertEqual(sut.queryItems, expectedQueryItems)
    }
    
    // MARK: - Helpers
    private func anyLocation() -> Location {
        return Location(city: "Anywhere", country: "In The World")
    }
    
}
