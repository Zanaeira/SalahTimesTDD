//
//  OverviewItem.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 23/08/2021.
//

import UIKit

struct OverviewItem: Hashable {
    let header: String
    let items: [Item]
    
    static let stubs = [
        OverviewItem(header: "London, UK", items: [
            Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:03", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Paris, France", items: [
            Item(title: "Fajr", body: "03:29", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:49", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:02", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:19", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:28", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Dhaka, Bangladesh", items: [
            Item(title: "Fajr", body: "03:32", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:51", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:01", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:17", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:25", image: UIImage(systemName: "moon.stars.fill"))
        ])
    ]
    
}
