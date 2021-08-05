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
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadTimes(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
        client.get(from: endpoint.url) { [weak self] result in
            guard self != nil else { return }
            
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
