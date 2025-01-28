//
//  DateUtility.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.08.2024.
//

import Foundation

struct DateUtility {
    static func createDateWith(hour: Int, minute: Int, from date: Date) -> Date? {
        let calendar = Calendar.current
        let componentsFromDatePicker = calendar.dateComponents([.year, .month, .day], from: date)
        
        var components = DateComponents()
        components.year = componentsFromDatePicker.year
        components.month = componentsFromDatePicker.month
        components.day = componentsFromDatePicker.day
        components.hour = hour
        components.minute = minute
        
       return calendar.date(from: components)
    }
}
