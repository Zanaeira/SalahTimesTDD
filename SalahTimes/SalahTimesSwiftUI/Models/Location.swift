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
	public let mithl: AladhanAPIEndpoint.Madhhab
	public let calculationAngle: AladhanAPIEndpoint.Method

	public init(location: String, mithl: AladhanAPIEndpoint.Madhhab, calculationAngle: AladhanAPIEndpoint.Method) {
		self.location = location
		self.mithl = mithl
		self.calculationAngle = calculationAngle
	}
}
