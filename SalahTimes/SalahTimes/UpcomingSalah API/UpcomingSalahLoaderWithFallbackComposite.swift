//
//  UpcomingSalahLoaderWithFallbackComposite.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation

public final class UpcomingSalahLoaderWithFallbackComposite: UpcomingSalahLoader {

	private let primaryLoader: RemoteLoader<UpcomingSalah>
	private let fallbackLoader: RemoteLoader<UpcomingSalah>

	public init(primaryLoader: RemoteLoader<UpcomingSalah>, fallbackLoader: RemoteLoader<UpcomingSalah>) {
		self.primaryLoader = primaryLoader
		self.fallbackLoader = fallbackLoader
	}

	public func load(from endpoint: Endpoint, completion: @escaping (Result<UpcomingSalah, LoaderError>) -> Void) {
		primaryLoader.load(from: endpoint) { [weak self] result in
			switch result {
			case let .success(upcomingSalah): completion(.success(upcomingSalah))
			case .failure:
				self?.fallbackLoader.load(from: endpoint, completion: completion)
			}
		}
	}

	public func load(from endpoint: any Endpoint) async -> Result<UpcomingSalah, LoaderError> {
		await withCheckedContinuation { continuation in
			load(from: endpoint) { result in
				continuation.resume(returning: result)
			}
		}
	}

}
