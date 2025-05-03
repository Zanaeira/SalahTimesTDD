//
//  RemoteLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import XCTest
import SalahTimes

class RemoteLoaderTestsTests: XCTestCase {

	func test_load_deliversConnectivityErrorOnHTTPClientError() {
		let (sut, httpClient, endpointSpy) = makeSUT()

		expect(sut, toCompleteWith: .failure(.connectivity), using: endpointSpy) {
			let httpClientError = NSError(domain: "Error", code: 0)
			httpClient.complete(with: httpClientError)
		}
	}

	func test_load_deliversErrorOnMapperError() {
		let (sut, httpClient, endpointSpy) = makeSUT(mapper: { _, _ in
			throw anyError()
		})

		expect(sut, toCompleteWith: .failure(.invalidData), using: endpointSpy) {
			httpClient.complete(withStatusCode: 200, data: anyData())
		}
	}

	func test_load_deliversMappedResource() {
		let resource = "any resource"
		let (sut, httpClient, endpointSpy) = makeSUT(mapper: { data, _ in
			String(data: data, encoding: .utf8)!
		})

		expect(sut, toCompleteWith: .success(resource), using: endpointSpy) {
			httpClient.complete(withStatusCode: 200, data: Data(resource.utf8))
		}
	}

	func test_load_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
		let httpClient = HTTPClientSpy()
		let endpointSpy = EndpointSpy.make()
		var sut: RemoteLoader<String>? = RemoteLoader<String>(client: httpClient, mapper: { _, _ in "any" })
		let (_, data) = salahTimesModelAndDataFor5thAug2021LondonUK()

		var capturedResults = [RemoteLoader<String>.Result]()
		sut?.load(from: endpointSpy) {
			capturedResults.append($0)
		}

		sut = nil
		httpClient.complete(withStatusCode: 200, data: data)

		XCTAssertTrue(capturedResults.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" }, file: StaticString = #file, line: UInt = #line) -> (RemoteLoader: RemoteLoader<String>, httpClient: HTTPClientSpy, endpoint: Endpoint) {
		let httpClient = HTTPClientSpy()
		let endpointSpy = EndpointSpy.make()
		let sut = RemoteLoader<String>(client: httpClient, mapper: mapper)
		trackForMemoryLeaks(sut, file: file, line: line)
		trackForMemoryLeaks(httpClient, file: file, line: line)

		return (sut, httpClient, endpointSpy)
	}

	private func expect(_ sut: RemoteLoader<String>, toCompleteWith result: RemoteLoader<String>.Result, using endpoint: Endpoint, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
		var capturedResults = [RemoteLoader<String>.Result]()
		sut.load(from: endpoint) {
			capturedResults.append($0)
		}

		action()

		XCTAssertEqual(capturedResults, [result], file: file, line: line)
	}

	private func anyLocation() -> String {
		return "London, UK"
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

