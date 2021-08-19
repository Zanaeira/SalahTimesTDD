//
//  Header.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import Foundation

struct Header {
    let date: Date
    var headerText: String {
        let dateFormatter = DateFormatter.headerDateFormatter
        
        return dateFormatter.string(from: date)
    }
}

private extension DateFormatter {
    static let headerDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter
    }()
}
