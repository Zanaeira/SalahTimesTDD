//
//  UpcomingSalahLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation

public typealias UpcomingSalahLoader = RemoteLoader<UpcomingSalah>

public extension UpcomingSalahLoader {
	convenience init(client: HTTPClient) {
		self.init(client: client, mapper: UpcomingSalahMapper.map)
	}
}
