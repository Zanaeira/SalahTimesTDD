//
//  Endpoint.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
}
