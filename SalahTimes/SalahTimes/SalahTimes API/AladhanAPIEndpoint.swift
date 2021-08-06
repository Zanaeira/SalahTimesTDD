//
//  AladhanAPIEndpoint.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import Foundation

public struct AladhanAPIEndpoint: Endpoint {
    
    public let path: String
    public let queryItems: [URLQueryItem]
    
    public var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.aladhan.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url!
    }
    
    public static func timingsByLocation(_ location: Location, on date: Date, madhhabForAsr: Madhhab = .hanafi, fajrIshaMethod: Method = .standard(method: .islamicSocietyOfNorthAmerica)) -> Endpoint {
        var queryItems = [
            URLQueryItem(name: "city", value: location.city),
            URLQueryItem(name: "country", value: location.country),
            URLQueryItem(name: "school", value: String(madhhabForAsr.rawValue))
        ]
        fajrIshaMethod.queryItems().forEach({queryItems.append($0)})
        
        return AladhanAPIEndpoint(path: "/v1/timingsByCity/\(dateFormattedForAPIRequest(date))", queryItems: queryItems)
    }
    
    public static func dateFormattedForAPIRequest(_ date: Date) -> String {
        let dateFormatter = DateFormatter.dateFormatterForAladhanAPIRequest
        
        return dateFormatter.string(from: date)
    }
    
}

extension AladhanAPIEndpoint {
    
    public enum Madhhab: Int {
        case shafii = 0
        case hanafi = 1
    }
    
    public struct MethodSettings {
        let fajrAngle: Double?
        let maghribAngle: Double?
        let ishaAngle: Double?
        
        public init(fajrAngle: Double?, maghribAngle: Double?, ishaAngle: Double?) {
            self.fajrAngle = fajrAngle
            self.maghribAngle = maghribAngle
            self.ishaAngle = ishaAngle
        }
                
        private func angleOrNull(_ angle: Double?) -> String {
            guard let angle = angle else { return "null" }
            
            return "\(angle)"
        }
        
        fileprivate func value() -> String {
            return "\(angleOrNull(fajrAngle)),\(angleOrNull(maghribAngle)),\(angleOrNull(ishaAngle))"
        }
    }
        
    public enum Method {
        case standard(method: CalculationMethod)
        case custom(methodSettings: MethodSettings)
        
        public func queryItems() -> [URLQueryItem] {
            switch self {
            case let .standard(method):
                return [URLQueryItem(name: "method", value: "\(method.rawValue)")]
            case let .custom(methodSettings):
                return [
                    URLQueryItem(name: "method", value: "99"),
                    URLQueryItem(name: "methodSettings", value: methodSettings.value())
                ]
            }
        }
        
        public func value() -> Int {
            switch self {
            case let .standard(method):
                return method.rawValue
            case .custom:
                return 99
            }
        }
    }
    
    public enum CalculationMethod: Int {
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
    
}

private extension DateFormatter {
    static let dateFormatterForAladhanAPIRequest: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter
    }()
}
