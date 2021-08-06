//
//  AladhanAPIEndpointTests.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import XCTest
import SalahTimes

class AladhanAPIEndpointTests: XCTestCase {
    
    func test_timingsByLocation_pathIsCorrectForDate() {
        let date = Date()
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: date)
        let expectedPath = "/v1/timingsByCity/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_timingsByLocation_queryItemsForCityAndCountryIncluded() {
        let date = Date()
        let location = Location(city: "London", country: "UK")
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(location, on: date)
        
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country)
        ]
        
        XCTAssertTrue(sut.queryItems.contains(expectedQueryItems[0]))
        XCTAssertTrue(sut.queryItems.contains(expectedQueryItems[1]))
    }
    
    func test_timingsByLocation_queryItemsIncludesSchoolForAsrTimeCalculation() {
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate(), madhhabForAsr: .shafii)
        let schoolForAsrTimeQueryItem = URLQueryItem(name: "school", value: "0")
        
        XCTAssertTrue(sut.queryItems.contains(schoolForAsrTimeQueryItem))
    }
    
    func test_timingsByLocation_queryItemsIncludesCalculationMethodForFajrAndIsha() {
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate())
        let calculationMethodQueryItem = URLQueryItem(name: "method", value: "2")
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItem))
    }
    
    func test_timingsByLocation_allowsCustomCalculationMethodForFajrAndIsha() {
        let methodSettings = AladhanAPIEndpoint.MethodSettings(fajrAngle: 18.5, maghribAngle: nil, ishaAngle: 17.5)
        let method = AladhanAPIEndpoint.Method.custom(methodSettings: methodSettings)
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate(), fajrIshaMethod: method)
        let calculationMethodQueryItems = [URLQueryItem(name: "method", value: "99"),
                                           URLQueryItem(name: "methodSettings", value: "18.5,null,17.5")]
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[0]))
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[1]))
    }
    
    func test_timingsByLocation_urlContainsHostSchemePathAndAllQueryItemsSpecified() {
        let location = Location(city: "London", country: "UK")
        let date = Date()
        let madhhab = AladhanAPIEndpoint.Madhhab.shafii
        let method = AladhanAPIEndpoint.Method.standard(method: .universityOfIslamicSciencesKarachi)
        
        let expectedURL = URL(string: "http://api.aladhan.com/v1/timingsByCity/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))?city=\(location.city)&country=\(location.country)&school=\(madhhab.rawValue)&method=\(method.value())")!
        
        let sut: Endpoint = AladhanAPIEndpoint.timingsByLocation(location, on: date, madhhabForAsr: madhhab, fajrIshaMethod: method)
        
        XCTAssertEqual(sut.url, expectedURL)
    }
    
    // MARK: - Helpers
    private func anyLocation() -> Location {
        return Location(city: "Anywhere", country: "In The World")
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
}

private extension DateFormatter {
    static let dateFormatterForAladhanAPIRequest: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter
    }()
}
