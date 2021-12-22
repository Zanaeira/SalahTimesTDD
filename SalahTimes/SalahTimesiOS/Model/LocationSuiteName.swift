//
//  LocationSuiteName.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 22/12/2021.
//

import Foundation

public struct LocationSuiteName: Codable {
    
    let location: String
    let suiteName: String
    
    public init(location: String, suiteName: String) {
        self.location = location
        self.suiteName = suiteName
    }
    
}
