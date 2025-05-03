//
//  TestHelpers.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation

func anyURL() -> URL {
	return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
	return Data("any data".utf8)
}

func anyError() -> Error {
	return NSError(domain: "any error", code: 0)
}
