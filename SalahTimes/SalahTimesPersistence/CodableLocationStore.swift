//
//  CodableLocationStore.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import Foundation

public final class CodableLocationStore: LocationStore {

	public init() {}

	public func add(_ location: Location) throws {
		throw StoreError.failedToInsert
	}

}
