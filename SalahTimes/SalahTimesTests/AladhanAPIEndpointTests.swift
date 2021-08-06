//
//  AladhanAPIEndpointTests.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import XCTest
import SalahTimes

struct AladhanAPIEndpoint {
    
    enum Madhhab: Int {
        case shafii = 0
        case hanafi = 1
    }
    
    let path: String
    let queryItems: [URLQueryItem]
    
    static func timingsByLocation(_ location: Location, on date: Date, madhhabForAsr: Madhhab = .hanafi) -> AladhanAPIEndpoint {
        return AladhanAPIEndpoint(path: "/v1/timingsByCity/\(dateFormattedForAPIRequest(date))", queryItems: [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country),
            URLQueryItem(name: "school", value: String(madhhabForAsr.rawValue))
        ])
    }
    
    static func dateFormattedForAPIRequest(_ date: Date) -> String {
        let dateFormatter = DateFormatter.dateFormatterForAladhanAPIRequest
        
        return dateFormatter.string(from: date)
    }
    
}

private extension DateFormatter {
    static let dateFormatterForAladhanAPIRequest: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter
    }()
}

class AladhanAPIEndpointTests: XCTestCase {
    
    func test_dateFormattedForAladhanAPIRequest_hasCorrectFormat() {
        let testDate = Date()
        
        XCTAssertEqual(AladhanAPIEndpoint.dateFormattedForAPIRequest(testDate), DateFormatter.dateFormatterForAladhanAPIRequest.string(from: testDate))
    }
    
    func test_timingsByLocation_pathIsCorrectForDate() {
        let date = Date()
        let sut = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: date)
        let expectedPath = "/v1/timingsByCity/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_timingsByLocation_queryItemsForCityAndCountryIncluded() {
        let date = Date()
        let location = Location(city: "London", country: "UK")
        let sut = AladhanAPIEndpoint.timingsByLocation(location, on: date)
        
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country)
        ]
        
        expectedQueryItems.forEach({
            XCTAssertTrue(sut.queryItems.contains($0))
        })
    }
    
    func test_timingsByLocation_queryItemsIncludesSchoolForAsrTimeCalculation() {
        let sut = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate(), madhhabForAsr: .shafii)
        let schoolForAsrTimeQueryItem = URLQueryItem(name: "school", value: "0")
        
        XCTAssertTrue(sut.queryItems.contains(schoolForAsrTimeQueryItem))
    }
    
    // MARK: - Helpers
    private func anyLocation() -> Location {
        return Location(city: "Anywhere", country: "In The World")
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
}
