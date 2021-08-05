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
        case invalidData
    }
    
    private let client: HTTPClient
    private let endpoint: Endpoint
    
    public init(endpoint: Endpoint, client: HTTPClient) {
        self.endpoint = endpoint
        self.client = client
    }
    
    public func loadTimes(for location: Location, on date: Date, completion: @escaping (Error) -> Void) {
        
        client.get(from: endpoint.url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        }
    }
    
}
