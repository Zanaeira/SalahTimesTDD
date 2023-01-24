//
//  SalahTimesMapper.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

final class SalahTimesMapper {
    
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> SalahTimes {
        guard response.statusCode == OK_200 else {
            throw TimesLoaderError.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.data.salahTimes
    }
    
}

private struct Root: Decodable {
    let data: TimingsData
}

private struct TimingsData: Decodable {
    let timings: Timings
    let date: TimingsDateData
    
    var salahTimes: SalahTimes {
        return SalahTimes(timestamp: date.timestamp, date: date.readable, fajr: timings.Fajr, sunrise: timings.Sunrise, zuhr: timings.Dhuhr, asr: timings.Asr, maghrib: timings.Maghrib, isha: timings.Isha)
    }
}

private struct Timings: Decodable {
    let Fajr, Sunrise, Dhuhr, Asr: String
    let Sunset, Maghrib, Isha, Imsak: String
    let Midnight: String
}

private struct TimingsDateData: Decodable {
    let readable: String
    let timestamp: String
}
