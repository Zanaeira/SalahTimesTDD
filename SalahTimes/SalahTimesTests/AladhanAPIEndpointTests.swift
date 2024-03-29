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
        let date = tomorrow()
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(anyAddress(), on: date)
        let expectedPath = "/v1/timingsByAddress/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_timingsByLocation_queryItemsForCityAndCountryIncluded() {
        let date = Date()
        let address = anyAddress()
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(address, on: date)
        
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "address", value: address)
        ]
        
        XCTAssertTrue(sut.queryItems.contains(expectedQueryItems[0]))
    }
    
    func test_timingsByLocation_queryItemsIncludesSchoolForAsrTimeCalculation() {
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(anyAddress(), on: anyDate(), madhhabForAsr: .shafii)
        let schoolForAsrTimeQueryItem = URLQueryItem(name: "school", value: "0")
        
        XCTAssertTrue(sut.queryItems.contains(schoolForAsrTimeQueryItem))
    }
    
    func test_timingsByLocation_queryItemsIncludesCalculationMethodForFajrAndIsha() {
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(anyAddress(), on: anyDate())
        let calculationMethodQueryItem = URLQueryItem(name: "method", value: "2")
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItem))
    }
    
    func test_timingsByLocation_allowsCustomCalculationMethodForFajrAndIsha() {
        let methodSettings = AladhanAPIEndpoint.MethodSettings(fajrAngle: 18.5, maghribAngle: nil, ishaAngle: 17.5)
        let method = AladhanAPIEndpoint.Method.custom(methodSettings: methodSettings)
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(anyAddress(), on: anyDate(), fajrIshaMethod: method)
        let calculationMethodQueryItems = [URLQueryItem(name: "method", value: "99"),
                                           URLQueryItem(name: "methodSettings", value: "18.5,null,17.5")]
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[0]))
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[1]))
    }
    
    func test_timingsByLocation_urlContainsHostSchemePathAndAllQueryItemsSpecified() {
        let address = "London"
        let date = tomorrow()
        let madhhab = AladhanAPIEndpoint.Madhhab.shafii
        let method = AladhanAPIEndpoint.Method.standard(method: .universityOfIslamicSciencesKarachi)
        
        let expectedURL = URL(string: "http://api.aladhan.com/v1/timingsByAddress/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))?address=\(address)&school=\(madhhab.rawValue)&method=1")!
        
        let sut: Endpoint = AladhanAPIEndpoint.timingsByAddress(address, on: date, madhhabForAsr: madhhab, fajrIshaMethod: method)
        
        XCTAssertEqual(sut.url, expectedURL)
    }
    
    // MARK: - Helpers
    private func anyAddress() -> String {
        return "Anywhere in the world"
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
    private func tomorrow() -> Date {
        let calendar = Calendar.current
        let today = Date()
        
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: today)
        
        return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime)!
    }
    
}

private extension DateFormatter {
    static let dateFormatterForAladhanAPIRequest: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter
    }()
}
