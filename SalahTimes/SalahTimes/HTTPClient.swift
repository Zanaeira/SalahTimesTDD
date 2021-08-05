//
//  HTTPClient.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}
