//
//  Endpoint.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 13/12/2021.
//

import Foundation

final class Endpoint {
    
    private let address: String
    private let date: Date
    
    private init(address: String, date: Date) {
        self.address = address
        self.date = date
    }
    
    static func timingsByAddress(_ address: String, on date: Date) -> Endpoint {
        return .init(address: address, date: date)
    }
    
}

extension Endpoint: CustomStringConvertible {
    
    var description: String {
        return "Address: \(address)\nDate: \(date)"
    }
    
}
