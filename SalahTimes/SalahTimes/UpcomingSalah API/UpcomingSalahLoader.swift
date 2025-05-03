//
//  UpcomingSalahLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation

public protocol UpcomingSalahLoader {
	typealias Result = Swift.Result<UpcomingSalah, LoaderError>

	func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void)
	func load(from endpoint: Endpoint) async -> Result
}
