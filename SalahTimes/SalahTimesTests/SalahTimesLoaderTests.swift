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
        
        var capturedErrors = [SalahTimesLoader.Error]()
        sut.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedErrors.append($0)
        }
        
        let httpClientError = NSError(domain: "Error", code: 0)
        httpClient.complete(with: httpClientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_loadTimes_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, httpClient) = makeSUT()
        
        var capturedErrors = [SalahTimesLoader.Error]()
        sut.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedErrors.append($0)
        }
        
        httpClient.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let loader = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        
        return (loader, httpClient)
    }
    
    private func anyLocation() -> Location {
        return Location(city: "London", country: "UK")
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
    private final class HTTPClientSpy: HTTPClient {
        
        typealias Completion = (HTTPURLResponse?, Error?) -> Void
        
        private var urlCompletions = [(url: URL, completion: Completion)]()
        
        func get(from url: URL, completion: @escaping Completion) {
            urlCompletions.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            urlCompletions[index].completion(nil, error)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: urlCompletions[index].url, statusCode: code, httpVersion: nil, headerFields: nil)
            urlCompletions[index].completion(response, nil)
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
