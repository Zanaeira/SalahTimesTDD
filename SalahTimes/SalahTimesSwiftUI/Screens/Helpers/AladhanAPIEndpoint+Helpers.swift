//
//  AladhanAPIEndpoint+Helpers.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 28/04/2025.
//

import SalahTimes

extension AladhanAPIEndpoint.Method {
	var angles: AladhanAPIEndpoint.MethodSettings? {
		guard case let .custom(methodSettings) = self else { return nil }
		return methodSettings
	}
}
