//
//  Item.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import UIKit

struct Item: Hashable {
    let title: String
    let body: String
    let image: UIImage?
    
    static let stubs = [
        Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
        Item(title: "Sunrise", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
        Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
        Item(title: "Asr", body: "18:06", image: UIImage(systemName: "sun.min.fill")),
        Item(title: "Maghrib", body: "20:21", image: UIImage(systemName: "sunset.fill")),
        Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill")),
    ]
}
