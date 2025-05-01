//
//  UpcomingSalahLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import XCTest
import SalahTimes


public struct UpcomingSalah: Equatable {
}

public final class UpcomingSalahLoader {
	public typealias Result = Swift.Result<UpcomingSalah, TimesLoaderError>

	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
		client.get(from: endpoint.url) { result in
			completion(.failure(.connectivity))
		}
	}
}

final class UpcomingSalahLoaderTests: XCTestCase {

	func test_load_deliversConnectivityErrorOnHTTPClientError() {
			let (sut, httpClient, endpointSpy) = makeSUT()

			expect(sut, toCompleteWith: .failure(.connectivity), using: endpointSpy) {
					let httpClientError = NSError(domain: "Error", code: 0)
					httpClient.complete(with: httpClientError)
			}
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (upcomingSalahTimesLoader: UpcomingSalahLoader, httpClient: HTTPClientSpy, endpoint: Endpoint) {
			let httpClient = HTTPClientSpy()
			let endpointSpy = EndpointSpy.make()
			let sut = UpcomingSalahLoader(client: httpClient)
			trackForMemoryLeaks(sut, file: file, line: line)
			trackForMemoryLeaks(httpClient, file: file, line: line)

			return (sut, httpClient, endpointSpy)
	}

	private func expect(_ sut: UpcomingSalahLoader, toCompleteWith result: UpcomingSalahLoader.Result, using endpoint: Endpoint, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
			var capturedResults = [UpcomingSalahLoader.Result]()
			sut.load(from: endpoint) {
					capturedResults.append($0)
			}

			action()

			XCTAssertEqual(capturedResults, [result], file: file, line: line)
	}

	private final class HTTPClientSpy: HTTPClient {
			typealias Completion = (Result<(Data, HTTPURLResponse), Error>) -> Void

			private var urlCompletions = [(url: URL, completion: Completion)]()

			func get(from url: URL, completion: @escaping Completion) {
					urlCompletions.append((url, completion))
			}

			func complete(with error: Error, at index: Int = 0) {
					urlCompletions[index].completion(.failure(error))
			}

			func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
					let response = HTTPURLResponse(url: urlCompletions[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
					urlCompletions[index].completion(.success((data, response)))
			}
	}

	private struct EndpointSpy: Endpoint {
			let path: String
			let queryItems: [URLQueryItem]
			var url: URL {
					URL(string: "https://a-given-url.com")!
			}

			static func make() -> EndpointSpy {
					.init(path: "", queryItems: [])
			}
	}

}
