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
        [
            Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:03", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill")),
        ],
        [
            Item(title: "Fajr", body: "03:29", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:49", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:02", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:19", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:28", image: UIImage(systemName: "moon.stars.fill")),
        ],
        [
            Item(title: "Fajr", body: "03:32", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:51", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:01", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:17", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:25", image: UIImage(systemName: "moon.stars.fill")),
        ],
        [
            Item(title: "Fajr", body: "03:35", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:53", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:00", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:15", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:22", image: UIImage(systemName: "moon.stars.fill")),
        ],
        [
            Item(title: "Fajr", body: "03:37", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:54", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "16:59", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:13", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:19", image: UIImage(systemName: "moon.stars.fill")),
        ]
    ]
    
}
