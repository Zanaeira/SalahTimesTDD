//
//  UpcomingSalahLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import XCTest
import SalahTimes

final class UpcomingSalahLoaderTests: XCTestCase {

	func test_load_deliversConnectivityErrorOnHTTPClientError() {
		let (sut, httpClient, endpointSpy) = makeSUT()

		expect(sut, toCompleteWith: .failure(.connectivity), using: endpointSpy) {
			let httpClientError = NSError(domain: "Error", code: 0)
			httpClient.complete(with: httpClientError)
		}
	}

	func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
		let (sut, httpClient, endpointSpy) = makeSUT()

		let sampleStatusCodes = [199, 201, 300, 400, 500]

		sampleStatusCodes.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: .failure(.invalidData), using: endpointSpy) {
				httpClient.complete(withStatusCode: code, data: makeUpcomingSalahJSON(), at: index)
			}
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
		let (sut, httpClient, endpointSpy) = makeSUT()

		expect(sut, toCompleteWith: .failure(.invalidData), using: endpointSpy) {
			let invalidJSON = Data("invalid json".utf8)
			httpClient.complete(withStatusCode: 200, data: invalidJSON)
		}
	}

	func test_load_deliversUpcomingSalahOn200HTTPResponseWithJSONTimes() {
		let (sut, httpClient, endpointSpy) = makeSUT()
		let upcomingSalah = UpcomingSalah(name: "Fajr", time: ISO8601DateFormatter().date(from: "2025-04-30T03:38:00+01:00")!, timezone: "Europe/London")
		let data = makeUpcomingSalahJSON()

		expect(sut, toCompleteWith: .success(upcomingSalah), using: endpointSpy) {
			httpClient.complete(withStatusCode: 200, data: data)
		}
	}

	func test_load_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
		let httpClient = HTTPClientSpy()
		let endpointSpy = EndpointSpy.make()
		var sut: UpcomingSalahLoader? = UpcomingSalahLoader(client: httpClient)
		let data = makeUpcomingSalahJSON()

		var capturedResults = [UpcomingSalahLoader.Result]()
		sut?.load(from: endpointSpy) {
			capturedResults.append($0)
		}

		sut = nil
		httpClient.complete(withStatusCode: 200, data: data)

		XCTAssertTrue(capturedResults.isEmpty)
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

	private func makeUpcomingSalahJSON() -> Data {
		let json = [
			"data" : [
				"timings": ["Fajr": "2025-04-30T03:38:00+01:00"],
				"meta": ["timezone": "Europe/London"]
			]
		]
		return try! JSONSerialization.data(withJSONObject: json)
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
