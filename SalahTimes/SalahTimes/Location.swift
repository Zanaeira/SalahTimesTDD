//
//  Location.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import Foundation

public struct Location {
    public let city: String
    public let country: String
    
    public init(city: String, country: String) {
        self.city = city
        self.country = country
    }
}
