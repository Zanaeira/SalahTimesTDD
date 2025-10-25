//
//  LocationStore.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import Foundation

public protocol LocationStore {
	func retrieve(_ locationName: String) throws -> Location
	func add(_ location: Location) throws
}
