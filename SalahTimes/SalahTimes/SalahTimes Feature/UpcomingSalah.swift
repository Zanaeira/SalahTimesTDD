//
//  UpcomingSalah.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation

public struct UpcomingSalah: Equatable {
	public let name: String
	public let time: Date

	public init(name: String, time: Date) {
		self.name = name
		self.time = time
	}
}
