//
//  SalahTimesLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 04/08/2021.
//

import Foundation
import XCTest
import SalahTimes

class SalahTimesLoaderTests: XCTestCase {
    
    func test_loadTimes_deliversConnectivityErrorOnHTTPClientError() {
        let (sut, httpClient) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity) {
            let httpClientError = NSError(domain: "Error", code: 0)
            httpClient.complete(with: httpClientError)
        }
    }
    
    func test_loadTimes_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, httpClient) = makeSUT()
        
        let sampleStatusCodes = [199, 201, 300, 400, 500]
        
        sampleStatusCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData) {
                httpClient.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_loadTimes_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, httpClient) = makeSUT()
        
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON =  Data("invalid json".utf8)
            httpClient.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let loader = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        
        return (loader, httpClient)
    }
    
    private func expect(_ sut: SalahTimesLoader, toCompleteWithError error: SalahTimesLoader.Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [Result<SalahTimes, SalahTimesLoader.Error>]()
        sut.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedResults.append($0)
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
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
