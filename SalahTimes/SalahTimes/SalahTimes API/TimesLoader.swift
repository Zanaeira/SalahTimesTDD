//
//  TimesLoader.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 07/11/2022.
//

import Foundation

public protocol TimesLoader {
    typealias Result = Swift.Result<SalahTimes, LoaderError>
    
    func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void)
		func load(from endpoint: Endpoint) async -> Result
}
