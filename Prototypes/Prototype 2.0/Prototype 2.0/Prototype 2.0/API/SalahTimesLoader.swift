//
//  SalahTimesLoader.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import Foundation

final class SalahTimesLoader {
    
    typealias Result = Swift.Result<SalahTimes, Error>
    
    func loadTimes(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
        print(endpoint)
        completion(.success(SalahTimes.sampleTimes))
    }
    
}
