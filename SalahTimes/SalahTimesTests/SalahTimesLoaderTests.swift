//
//  SalahTimesLoaderTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 04/08/2021.
//

import XCTest
import SalahTimes

class SalahTimesLoaderTests: XCTestCase {
    
    func test_loadTimes_deliversConnectivityErrorOnHTTPClientError() {
        let (sut, httpClient, endpointSpy) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), using: endpointSpy) {
            let httpClientError = NSError(domain: "Error", code: 0)
            httpClient.complete(with: httpClientError)
        }
    }
    
    func test_loadTimes_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, httpClient, endpointSpy) = makeSUT()
        
        let sampleStatusCodes = [199, 201, 300, 400, 500]
        
        sampleStatusCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), using: endpointSpy) {
                let (_, data) = salahTimesModelAndDataFor5thAug2021LondonUK()
                httpClient.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    func test_loadTimes_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, httpClient, endpointSpy) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), using: endpointSpy) {
            let invalidJSON =  Data("invalid json".utf8)
            httpClient.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadTimes_deliversTimesOn200HTTPResponseWithJSONTimes() {
        let (sut, httpClient, endpointSpy) = makeSUT()
        let (salahTimes, data) = salahTimesModelAndDataFor5thAug2021LondonUK()
        
        expect(sut, toCompleteWith: .success(salahTimes), using: endpointSpy) {
            httpClient.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_loadTimes_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        var sut: SalahTimesLoader? = SalahTimesLoader(client: httpClient)
        let (_, data) = salahTimesModelAndDataFor5thAug2021LondonUK()
        
        var capturedResults = [SalahTimesLoader.Result]()
        sut?.loadTimes(from: endpointSpy) {
            capturedResults.append($0)
        }
        
        sut = nil
        httpClient.complete(withStatusCode: 200, data: data)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy, endpoint: Endpoint) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let sut = SalahTimesLoader(client: httpClient)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(httpClient, file: file, line: line)
        
        return (sut, httpClient, endpointSpy)
    }
        
    private func expect(_ sut: SalahTimesLoader, toCompleteWith result: SalahTimesLoader.Result, using endpoint: Endpoint, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [SalahTimesLoader.Result]()
        sut.loadTimes(from: endpoint) {
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
