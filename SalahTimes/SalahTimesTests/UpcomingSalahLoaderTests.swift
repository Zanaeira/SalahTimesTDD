//
//  UpcomingSalahLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import XCTest
import SalahTimes


public struct UpcomingSalah: Equatable {
	let name: String
	let time: Date
}

final class UpcomingSalahMapper {
	private static let OK_200: Int = 200

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> UpcomingSalah {
			guard response.statusCode == OK_200 else {
					throw TimesLoaderError.invalidData
			}

		guard let upcomingSalah = try JSONDecoder().decode(Root.self, from: data).data.upcomingSalah else {
			throw TimesLoaderError.invalidData
		}

		return upcomingSalah
	}

	private struct Root: Decodable {
		let data: TimingsData
	}

	private struct TimingsData: Decodable {
		let timings: Timings

		var upcomingSalah: UpcomingSalah? {
			let salahs = [timings.Fajr, timings.Dhuhr, timings.Asr, timings.Maghrib, timings.Isha]
			for (index, salahTime) in salahs.compactMap({ $0 }).enumerated() {
				guard Self.salahNames.indices.contains(index) else { continue }
				let name = Self.salahNames[index]
				guard let time = ISO8601DateFormatter().date(from: salahTime) else { continue }
				return .init(name: name, time: time)
			}

			return nil
		}

		private static let salahNames = ["Fajr", "Zuhr", "Asr", "Maghrib", "Isha"]

	}

	private struct Timings: Decodable {
		let Fajr, Dhuhr, Asr, Maghrib, Isha: String?
	}
}

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
}

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
				let upcomingSalah = ["timings": ["Fajr": "2025-04-30T03:38:00+01:00"]]
				httpClient.complete(withStatusCode: code, data: makeUpcomingSalahJSON(upcomingSalah), at: index)
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
		let upcomingSalah = UpcomingSalah(name: "Fajr", time: ISO8601DateFormatter().date(from: "2025-04-30T03:38:00+01:00")!)
		let data = makeUpcomingSalahJSON(["timings": ["Fajr": "2025-04-30T03:38:00+01:00"]])

		expect(sut, toCompleteWith: .success(upcomingSalah), using: endpointSpy) {
			httpClient.complete(withStatusCode: 200, data: data)
		}
	}

	func test_load_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
		let httpClient = HTTPClientSpy()
		let endpointSpy = EndpointSpy.make()
		var sut: UpcomingSalahLoader? = UpcomingSalahLoader(client: httpClient)
		let data = makeUpcomingSalahJSON(["timings": ["Fajr": "2025-04-30T03:38:00+01:00"]])

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

	private func makeUpcomingSalahJSON(_ timings: [String: [String: String]]) -> Data {
		let json = ["data": timings]
		print(json)
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
