//
//  AladhanAPIEndpoint+QueryItemTypes.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import Foundation

extension AladhanAPIEndpoint {
    
    public enum Madhhab: Int {
        case shafii = 0
        case hanafi = 1
    }
    
    public struct MethodSettings: Codable {
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
        
    public enum Method: Codable {
        case standard(method: CalculationMethod)
        case custom(methodSettings: MethodSettings)
        
        func queryItems() -> [URLQueryItem] {
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
    }
    
    public enum CalculationMethod: Int, Codable {
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
