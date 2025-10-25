//
//  LocationStore.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import Foundation

public protocol LocationStore {
	func add(_ location: Location) throws
}
