//
//  SalahTimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public typealias SalahTimesLoader = RemoteLoader<SalahTimes>

public extension SalahTimesLoader {
	convenience init(client: HTTPClient) {
		self.init(client: client, mapper: SalahTimesMapper.map)
	}
}
