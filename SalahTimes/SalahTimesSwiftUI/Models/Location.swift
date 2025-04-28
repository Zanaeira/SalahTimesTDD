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
	public internal(set) var calculationAngle: AladhanAPIEndpoint.Method {
		didSet {
			guard let encodedAngles = try? JSONEncoder().encode(calculationAngle) else { return }
			userDefaults.set(encodedAngles, forKey: "FajrIsha")
		}
	}

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
		if case let .custom(lhsMethodSettings) = lhs, case let .custom(rhsMethodSettings) = rhs {
			return lhsMethodSettings == rhsMethodSettings
		}
		return false
	}
}

extension AladhanAPIEndpoint.MethodSettings: @retroactive Equatable {
	public static func == (lhs: AladhanAPIEndpoint.MethodSettings, rhs: AladhanAPIEndpoint.MethodSettings) -> Bool {
		lhs.fajrAngle == rhs.fajrAngle
		&& lhs.maghribAngle == rhs.maghribAngle
		&& lhs.ishaAngle == rhs.ishaAngle
	}
}
