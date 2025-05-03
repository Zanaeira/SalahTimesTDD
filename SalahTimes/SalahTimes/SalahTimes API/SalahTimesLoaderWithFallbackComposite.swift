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
    
    public func load(from endpoint: Endpoint, completion: @escaping (Result<SalahTimes, TimesLoaderError>) -> Void) {
        primaryLoader.load(from: endpoint) { [weak self] result in
            switch result {
            case let .success(salahTimes): completion(.success(salahTimes))
            case .failure:
                self?.fallbackLoader.load(from: endpoint, completion: completion)
            }
        }
    }

		public func load(from endpoint: any Endpoint) async -> TimesLoader.Result {
			await withCheckedContinuation { continuation in
				load(from: endpoint) { result in
					continuation.resume(returning: result)
				}
			}
		}

}
