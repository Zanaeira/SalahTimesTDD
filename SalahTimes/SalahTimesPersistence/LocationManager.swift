//
//  LocationManager.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 23/10/2025.
//

import Foundation
import SalahTimes

public final class LocationManager {

	private let loader: TimesLoader
	public private(set) var locations = [String]()

	public init(loader: TimesLoader) {
		self.loader = loader
	}

	public func add(location: String) async throws {
		let result = await loader.load(from: AladhanAPIEndpoint.timingsByAddress("", on: .now))
		switch result {
		case .success:
			locations.append(location)
		case .failure(let error):
			throw error
		}
	}
}
