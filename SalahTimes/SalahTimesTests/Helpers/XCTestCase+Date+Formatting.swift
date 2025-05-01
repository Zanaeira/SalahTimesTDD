//
//  XCTestCase+Date+Formatting.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 01/05/2025.
//

import XCTest

extension XCTestCase {
	func anyAddress() -> String {
		return "Anywhere in the world"
	}

	func anyDate() -> Date {
			return Date()
	}

	func tomorrow() -> Date {
			let calendar = Calendar.current
			let today = Date()

			let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: today)

			return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime)!
	}
}

extension DateFormatter {
	static let dateFormatterForAladhanAPIRequest: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"

		return dateFormatter
	}()
}
