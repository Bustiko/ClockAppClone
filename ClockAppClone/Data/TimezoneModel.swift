//
//  TimezoneModel.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import Foundation

struct TimezoneList: Codable {
    let zones: [Zone]
}

struct Zone: Codable {
    let countryName: String
    let zoneName: String
    let gmtOffset: Int64
    let timestamp: Int64
}
