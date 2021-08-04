//
//  SalahTimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public final class SalahTimesLoader {
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    private let httpClient: HTTPClient
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint, httpClient: HTTPClient) {
        self.endpoint = endpoint
        self.httpClient = httpClient
    }
    
    public func loadTimes(for location: Location, on date: Date, completion: @escaping (Error) -> Void) {
        httpClient.get(from: endpoint.url) { error in
            completion(.connectivity)
        }
    }
    
}
