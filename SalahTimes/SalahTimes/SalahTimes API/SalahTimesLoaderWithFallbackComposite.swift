//
//  SalahTimesLoaderWithFallbackComposite.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 07/11/2022.
//

import Foundation

public final class SalahTimesLoaderWithFallbackComposite: TimesLoader {
    
    private let primaryLoader: TimesLoader
    private let fallbackLoader: TimesLoader
    
    public init(primaryLoader: TimesLoader, fallbackLoader: TimesLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public func loadTimes(from endpoint: Endpoint, completion: @escaping (Result<SalahTimes, TimesLoaderError>) -> Void) {
        primaryLoader.loadTimes(from: endpoint) { [weak self] result in
            switch result {
            case let .success(salahTimes): completion(.success(salahTimes))
            case .failure:
                self?.fallbackLoader.loadTimes(from: endpoint, completion: completion)
            }
        }
    }
    
}
