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
    
    typealias MethodSettings = (fajrAngle: String, maghribAngle: String, ishaAngle: String)
    
    enum Method {
        case standard(method: CalculationMethod)
        case custom(methodSettings: MethodSettings)
        
        func queryItems() -> [URLQueryItem] {
            switch self {
            case let .standard(method):
                return [URLQueryItem(name: "method", value: "\(method.rawValue)")]
            case let .custom(methodSettings):
                return [
                    URLQueryItem(name: "method", value: "99"),
                    URLQueryItem(name: "methodSettings", value: "\(methodSettings.fajrAngle),\(methodSettings.maghribAngle),\(methodSettings.ishaAngle)")
                ]
            }
        }
    }
    
    enum CalculationMethod: Int {
        case shiaIthnaAnsari = 0
        case universityOfIslamicSciencesKarachi = 1
        case islamicSocietyOfNorthAmerica = 2
        case muslimWorldLeague = 3
        case ummAlQuraUniversityMakkah = 4
        case egyptianGeneralAuthorityOfSurvey = 5
        case InstituteOfGeophysicsUniversityOfTehran = 7
        case gulfRegion = 8
        case kuwait = 9
        case qatar = 10
        case majlisUgamaIslamSingapuraSingapore = 11
        case unionOrganizationislamicDeFrance = 12
        case diyanetİşleriBaşkanlığıTurkey = 13
        case spiritualAdministrationOfMuslimsOfRussia = 14
    }
    
    let path: String
    let queryItems: [URLQueryItem]
    
    static func timingsByLocation(_ location: Location, on date: Date, madhhabForAsr: Madhhab = .hanafi, fajrIshaMethod: Method = .standard(method: .islamicSocietyOfNorthAmerica)) -> AladhanAPIEndpoint {
        var queryItems = [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country),
            URLQueryItem(name: "school", value: String(madhhabForAsr.rawValue))
        ]
        fajrIshaMethod.queryItems().forEach({queryItems.append($0)})
        
        return AladhanAPIEndpoint(path: "/v1/timingsByCity/\(dateFormattedForAPIRequest(date))", queryItems: queryItems)
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
    
    func test_timingsByLocation_queryItemsIncludesCalculationMethodForFajrAndIsha() {
        let sut = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate())
        let calculationMethodQueryItem = URLQueryItem(name: "method", value: "2")
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItem))
    }
    
    func test_timingsByLocation_allowsCustomCalculationMethodForFajrAndIsha() {
        let method = AladhanAPIEndpoint.Method.custom(methodSettings: ("18.5", "null", "17.5"))
        let sut = AladhanAPIEndpoint.timingsByLocation(anyLocation(), on: anyDate(), fajrIshaMethod: method)
        let calculationMethodQueryItems = [URLQueryItem(name: "method", value: "99"),
                                           URLQueryItem(name: "methodSettings", value: "18.5,null,17.5")]
        
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[0]))
        XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[1]))
    }
    
    // MARK: - Helpers
    private func anyLocation() -> Location {
        return Location(city: "Anywhere", country: "In The World")
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
}
