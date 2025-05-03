//
//  SalahTimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public final class SalahTimesLoader: TimesLoader {
	public typealias Result = TimesLoader.Result

	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
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

	public func load(from endpoint: any Endpoint) async -> Result {
		await withCheckedContinuation { continuation in
			load(from: endpoint) { result in
				continuation.resume(returning: result)
			}
		}
	}

}
