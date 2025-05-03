//
//  RemoteLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation

public final class RemoteLoader<Resource> {
	public typealias Result = Swift.Result<Resource, LoaderError>
	public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource

	private let client: HTTPClient
	private let mapper: Mapper

	public init(client: HTTPClient, mapper: @escaping Mapper) {
		self.client = client
		self.mapper = mapper
	}

	public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
		client.get(from: endpoint.url) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success((data, response)):
				guard let resource = try? self.mapper(data, response) else {
					return completion(.failure(.invalidData))
				}
				completion(.success(resource))
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

