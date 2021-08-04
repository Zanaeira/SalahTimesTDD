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
        sut.loadTimes(for: Location(city: "London", country: "UK"), on: Date()) {
            capturedErrors.append($0)
        }
        
        let httpClientError = NSError(domain: "Error", code: 0)
        httpClient.complete(with: httpClientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let loader = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        
        return (loader, httpClient)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        
        typealias Completion = (Error) -> Void
        
        private var urlCompletions = [(url: URL, completion: Completion)]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            urlCompletions.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            urlCompletions[index].completion(error)
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
