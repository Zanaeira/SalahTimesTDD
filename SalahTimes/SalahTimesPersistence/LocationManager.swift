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
	private let store: LocationStore

	public init(loader: TimesLoader, store: LocationStore) {
		self.loader = loader
		self.store = store
	}

	public func add(location: String, using endpoint: Endpoint) async throws {
		let result = await loader.load(from: endpoint)
		switch result {
		case .success(let salahTimes):
			try store.add(.init(name: location, salahTimes: salahTimes))
		case .failure(let error):
			throw error
		}
	}
}
