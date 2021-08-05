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
                guard let salahTimes = try? SalahTimesMapper.map(data, response) else {
                    return completion(.failure(.invalidData))
                }
                
                completion(.success(salahTimes))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
}

private final class SalahTimesMapper {
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> SalahTimes {
        guard response.statusCode == 200 else {
            throw SalahTimesLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.data.salahTimes
    }
    
    private struct Root: Decodable {
        let data: TimingsData
    }
    
    private struct TimingsData: Decodable {
        let timings: Timings
        let date: TimingsDateData
        
        var salahTimes: SalahTimes {
            return SalahTimes(date: date(from: date.readable), fajr: timings.Fajr, sunrise: timings.Sunrise, zuhr: timings.Dhuhr, asr: timings.Asr, maghrib: timings.Maghrib, isha: timings.Isha)
        }
        
        private func date(from readable: String) -> Date {
            DateFormatter.readableDateFormatterForAladhanAPI.date(from: readable)!
        }
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
}

private extension DateFormatter {
    static let readableDateFormatterForAladhanAPI: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM y"
        
        return dateFormatter
    }()
}
