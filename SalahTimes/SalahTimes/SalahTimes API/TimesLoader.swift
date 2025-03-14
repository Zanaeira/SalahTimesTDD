//
//  TimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 07/11/2022.
//

import Foundation

public protocol TimesLoader {
    typealias Result = Swift.Result<SalahTimes, TimesLoaderError>
    
    func loadTimes(from endpoint: Endpoint, completion: @escaping (Result) -> Void)
		func loadTimes(from endpoint: Endpoint) async -> Result
}
