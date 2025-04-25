//
//  Locations.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/04/2025.
//

import Foundation
import SalahTimes

public struct Location: Identifiable {
	public let id = UUID()
	public let location: String
	public internal(set) var mithl: AladhanAPIEndpoint.Madhhab {
		didSet { userDefaults.set(mithl.rawValue, forKey: "Mithl") }
	}
	public let calculationAngle: AladhanAPIEndpoint.Method

	private let userDefaults: UserDefaults

	public init(userDefaults: UserDefaults, location: String, mithl: AladhanAPIEndpoint.Madhhab, calculationAngle: AladhanAPIEndpoint.Method) {
		self.userDefaults = userDefaults
		self.location = location
		self.mithl = mithl
		self.calculationAngle = calculationAngle
	}
}

extension Location: Equatable {
	public static func == (lhs: Location, rhs: Location) -> Bool {
		lhs.id == rhs.id
		&& lhs.location == rhs.location
		&& lhs.mithl == rhs.mithl
		&& lhs.calculationAngle == rhs.calculationAngle
	}
}

extension AladhanAPIEndpoint.Method: @retroactive Equatable {
	public static func == (lhs: AladhanAPIEndpoint.Method, rhs: AladhanAPIEndpoint.Method) -> Bool {
		if case .standard = lhs, case .standard = rhs { return true }
		if case .custom = lhs, case .custom = rhs { return true }
		return false
	}
}
