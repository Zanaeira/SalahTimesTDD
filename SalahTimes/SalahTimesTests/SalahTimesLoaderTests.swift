//
//  SalahTimesLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 04/08/2021.
//

import Foundation
import XCTest

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
}

class SalahTimesLoader {
    
    enum Error: Swift.Error {
        case connectivity
    }
    
    private let httpClient: HTTPClient
    private let endpoint: Endpoint
    
    init(endpoint: Endpoint, httpClient: HTTPClient) {
        self.endpoint = endpoint
        self.httpClient = httpClient
    }
    
    func loadTimes(for location: Location, on date: Date, completion: @escaping (Error) -> Void) {
        httpClient.get(from: endpoint.url) { error in
            completion(.connectivity)
        }
    }
    
}

struct Location {
    let city: String
    let country: String
}

class SalahTimesLoaderTests: XCTestCase {
    
    func test_loadTimes_deliversConnectivityErrorOnHTTPClientError() {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let sut = SalahTimesLoader(endpoint: endpointSpy, httpClient: httpClient)
        
        var capturedErrors = [SalahTimesLoader.Error]()
        sut.loadTimes(for: Location(city: "London", country: "UK"), on: Date()) {
            capturedErrors.append($0)
        }
        
        let httpClientError = NSError(domain: "Error", code: 0)
        httpClient.complete(with: httpClientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
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
