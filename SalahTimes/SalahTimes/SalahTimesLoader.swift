//
//  SalahTimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public final class SalahTimesLoader {
    
    public typealias Result = Swift.Result<SalahTimes, Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let client: HTTPClient
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint, client: HTTPClient) {
        self.endpoint = endpoint
        self.client = client
    }
    
    public func loadTimes(for location: Location, on date: Date, completion: @escaping (Result) -> Void) {
        
        client.get(from: endpoint.url) { result in
            switch result {
            case let .success((data, response)):
                guard response.statusCode == 200,
                      let root = try? JSONDecoder().decode(Root.self, from: data) else {
                    return completion(.failure(.invalidData))
                }
                
                completion(.success(self.map(from: root.data)))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private func map(from data: TimingsData) -> SalahTimes {
        return SalahTimes(date: date(from: data.date.readable), fajr: data.timings.Fajr, sunrise: data.timings.Sunrise, zuhr: data.timings.Dhuhr, asr: data.timings.Asr, maghrib: data.timings.Maghrib, isha: data.timings.Isha)
    }
    
    private func date(from readable: String) -> Date {
        DateFormatter.readableDateFormatterForAladhanAPI.date(from: readable)!
    }
    
}

private struct Root: Decodable {
    let data: TimingsData
}

private struct TimingsData: Decodable {
    let timings: Timings
    let date: TimingsDateData
}

private struct Timings: Decodable {
    let Fajr, Sunrise, Dhuhr, Asr: String
    let Sunset, Maghrib, Isha, Imsak: String
    let Midnight: String
}

struct TimingsDateData: Decodable {
    let readable: String
    let timestamp: String
}

private extension DateFormatter {
    static let readableDateFormatterForAladhanAPI: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM y"
        
        return dateFormatter
    }()
}
