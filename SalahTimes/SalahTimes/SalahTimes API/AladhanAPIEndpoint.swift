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
    
    private init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
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
    
    // MARK: - Helpers
    
    private static func dateFormattedForAPIRequest(_ date: Date) -> String {
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
