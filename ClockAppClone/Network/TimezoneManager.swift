//
//  TimezoneManager.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import Foundation

@MainActor class TimezoneManager: ObservableObject {
    @Published var timezoneData = TimezoneList(zones: [])
    
    func fetchData() async {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"], let data: TimezoneList = await DataManager().fetchData(from: "https://api.timezonedb.com/v2.1/list-time-zone?key=\(apiKey)&format=json") else {
            return
        }
        timezoneData = data
    }
}
