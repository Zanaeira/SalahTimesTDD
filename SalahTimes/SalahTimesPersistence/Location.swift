//
//  Location.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 24/10/2025.
//

import Foundation
import SalahTimes

public struct Location: Equatable {
	public let name: String
	public let salahTimes: SalahTimes

	public init(name: String, salahTimes: SalahTimes) {
		self.name = name
		self.salahTimes = salahTimes
	}
}
