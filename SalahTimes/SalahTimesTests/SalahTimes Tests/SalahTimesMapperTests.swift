//
//  SalahTimesMapperTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 04/08/2021.
//

import XCTest
import SalahTimes

class SalahTimesMapperTests: XCTestCase {

	func test_map_throwsErrorOnNon200HTTPResponse() throws {
		let (_, data) = salahTimesModelAndDataFor5thAug2021LondonUK()
		let sampleStatusCodes = [199, 201, 300, 400, 500]

		try sampleStatusCodes.forEach { code in
			XCTAssertThrowsError(
				try SalahTimesMapper.map(data, HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
		let invalidJSON = Data("invalid json".utf8)

		XCTAssertThrowsError(
			try SalahTimesMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
		)
	}

	func test_map_deliversTimesOn200HTTPResponseWithJSONTimes() throws {
		let (salahTimes, data) = salahTimesModelAndDataFor5thAug2021LondonUK()

		let result = try SalahTimesMapper.map(data, HTTPURLResponse(statusCode: 200))
		XCTAssertEqual(result, salahTimes)
	}

}
