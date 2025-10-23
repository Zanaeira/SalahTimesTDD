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
	public private(set) var locations = [Location]()

	public init(loader: TimesLoader) {
		self.loader = loader
	}

	public func add(location: String, using endpoint: Endpoint) async throws {
		let result = await loader.load(from: endpoint)
		switch result {
		case .success(let salahTimes):
			locations.append(.init(name: location, salahTimes: salahTimes))
		case .failure(let error):
			throw error
		}
	}
}
