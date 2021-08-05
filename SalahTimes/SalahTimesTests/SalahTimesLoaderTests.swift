//
//  SalahTimesLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 04/08/2021.
//

import Foundation
import XCTest
@testable import SalahTimes

class SalahTimesLoaderTests: XCTestCase {
    
    func test_loadTimes_deliversConnectivityErrorOnHTTPClientError() {
        let (sut, httpClient) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let httpClientError = NSError(domain: "Error", code: 0)
            httpClient.complete(with: httpClientError)
        }
    }
    
    func test_loadTimes_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, httpClient) = makeSUT()
        
        let sampleStatusCodes = [199, 201, 300, 400, 500]
        
        sampleStatusCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                httpClient.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_loadTimes_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, httpClient) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON =  Data("invalid json".utf8)
            httpClient.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadTimes_deliversTimesOn200HTTPResponseWithJSONItems() {
        let (sut, httpClient) = makeSUT()
        
        let date = Date(timeIntervalSince1970: 1628118000)
        
        let salahTimes = SalahTimes(date: date, fajr: "03:27", sunrise: "05:31", zuhr: "13:07", asr: "17:14", maghrib: "20:42", isha: "22:44")
        
        let sampleJSON = [
            "data": [
                "timings": [
                    "Fajr": "03:27",
                    "Sunrise": "05:31",
                    "Dhuhr": "13:07",
                    "Asr": "17:14",
                    "Sunset": "20:42",
                    "Maghrib": "20:42",
                    "Isha": "22:44",
                    "Imsak": "03:17",
                    "Midnight": "01:06",
                ],
                "date": [
                    "readable": "05 Aug 2021",
                    "timestamp": "1628118000",
                ]
            ]
        ]
        
        expect(sut, toCompleteWith: .success(salahTimes)) {
            let json = try! JSONSerialization.data(withJSONObject: sampleJSON)
            httpClient.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let loader = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        
        return (loader, httpClient)
    }
    
    private func expect(_ sut: SalahTimesLoader, toCompleteWith result: SalahTimesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [SalahTimesLoader.Result]()
        sut.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedResults.append($0)
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func anyLocation() -> Location {
        return Location(city: "London", country: "UK")
    }
    
    private func anyDate() -> Date {
        return Date()
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
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
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
