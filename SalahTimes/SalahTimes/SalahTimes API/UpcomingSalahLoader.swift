//
//  UpcomingSalahLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation

public final class UpcomingSalahLoader {
	public typealias Result = Swift.Result<UpcomingSalah, TimesLoaderError>

	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
		client.get(from: endpoint.url) { [weak self] result in
			guard self != nil else { return }

			switch result {
			case .success(let (date, response)):
				guard let upcomingSalah = try? UpcomingSalahMapper.map(date, response) else {
					return completion(.failure(.invalidData))
				}
				completion(.success(upcomingSalah))
			case .failure:
				completion(.failure(.connectivity))
			}
		}
	}

	public func load(from endpoint: any Endpoint) async -> Result {
		await withCheckedContinuation { continuation in
			load(from: endpoint) { result in
				continuation.resume(returning: result)
			}
		}
	}
}
