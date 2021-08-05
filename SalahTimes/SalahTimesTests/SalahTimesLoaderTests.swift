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
                let (_, data) = sampleSalahTimesJSON()
                httpClient.complete(withStatusCode: code, data: data, at: index)
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
    
    func test_loadTimes_deliversTimesOn200HTTPResponseWithJSONTimes() {
        let (sut, httpClient) = makeSUT()
        let (salahTimes, data) = sampleSalahTimesJSON()
        
        expect(sut, toCompleteWith: .success(salahTimes)) {
            httpClient.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_loadTimes_doesNotDeliverResultsAfterSUTInstanceHasBeenDeallocated() {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        var sut: SalahTimesLoader? = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        let (_, data) = sampleSalahTimesJSON()
        
        var capturedResults = [SalahTimesLoader.Result]()
        sut?.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedResults.append($0)
        }
        
        sut = nil
        httpClient.complete(withStatusCode: 200, data: data)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (salahTimesLoader: SalahTimesLoader, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let endpointSpy = EndpointSpy.make()
        let sut = SalahTimesLoader(endpoint: endpointSpy, client: httpClient)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(httpClient, file: file, line: line)
        
        return (sut, httpClient)
    }
        
    private func expect(_ sut: SalahTimesLoader, toCompleteWith result: SalahTimesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [SalahTimesLoader.Result]()
        sut.loadTimes(for: anyLocation(), on: anyDate()) {
            capturedResults.append($0)
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func sampleSalahTimesJSON() -> (model: SalahTimes, data: Data) {
        let timestamp: Double = 1628118000
        
        let (salahTimes, salahTimesJSON) = makeSalahTimes(
            fajr: "03:27", sunrise: "05:31", zuhr: "13:07", asr: "17:14",
            sunset: "20:42", maghrib: "20:42", isha: "22:44", imsak: "03:17",
            midnight: "01:06", readableDate: "05 Aug 2021", timestamp: timestamp)
        
        let data = makeSalahTimesJSON(salahTimesJSON)
        
        return (salahTimes, data)
    }
    
    private func makeSalahTimes(fajr: String, sunrise: String, zuhr: String, asr: String, sunset: String, maghrib: String, isha: String, imsak: String, midnight: String, readableDate: String, timestamp: Double) -> (model: SalahTimes, json: [String: [String: String]]) {
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let salahTimesModel = SalahTimes(date: date, fajr: fajr, sunrise: sunrise, zuhr: zuhr, asr: asr, maghrib: maghrib, isha: isha)
        
        let salahTimesJSON = [
            "timings": [
                "Fajr": fajr,
                "Sunrise": sunrise,
                "Dhuhr": zuhr,
                "Asr": asr,
                "Sunset": sunset,
                "Maghrib": maghrib,
                "Isha": isha,
                "Imsak": imsak,
                "Midnight": midnight,
            ],
            "date": [
                "readable": readableDate,
                "timestamp": "\(timestamp)",
            ]
        ]
        
        return (salahTimesModel, salahTimesJSON)
    }
    
    private func makeSalahTimesJSON(_ timings: [String: [String: String]]) -> Data {
        let json = ["data": timings]
        return try! JSONSerialization.data(withJSONObject: json)
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
