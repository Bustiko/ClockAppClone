//
//  Constants.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 8.08.2024.
//

import SwiftUI

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM d"
    return formatter
}()

let stopwatchFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm:ss.SS"
    return formatter
}()

let timerFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}()

func alarmFormattedRemainingTime(remainingTime: TimeInterval) -> String {
    guard remainingTime > 0 else { return "All alarms are off" }
    
    let days = Int(remainingTime / 86400)
    let formatter = DateComponentsFormatter()
    
    if days > 0 {
        formatter.allowedUnits = [.day]
    } else {
        formatter.allowedUnits = [.hour, .minute]
    }
    
    formatter.zeroFormattingBehavior = .dropAll
    formatter.unitsStyle = .full
    
    return "Alarm in \(formatter.string(from: remainingTime)?.replacingOccurrences(of: ",", with: "\n") ?? "")"
}



func alarmFormattedDate(remainingTime: TimeInterval) -> String {
    guard remainingTime > 0 else { return "" }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM d, HH:mm"
    return formatter.string(from: Date.now + remainingTime)
    
    
}


func formattedTimer(totalSeconds: Int) -> String {
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60
    
    var components: [String] = []
    
    if hours > 0 {
        components.append("\(String(format: "%2d", hours))")
        if minutes == 0 && seconds == 0 {
            components.append("00")
            components.append("00")
        }
        
    }
    
    if minutes > 0 {
        components.append(String(format: (hours > 0) ? "%02d" : "%2d", minutes))
        if seconds == 0 {
            components.append("00")
        }
       
    }
    
    if seconds > 0 {
        components.append(String(format: (hours > 0 && minutes > 0) ? "%02d" : "%2d", seconds))
    }
    
    return components.joined(separator: " : ")
    
}

func formattedTimeZone(from offset: Int) -> String {
        let hours = offset / 3600
    
        let sign = (hours >= 0) ? "+" : "-"
    
        return "GMT\(sign)\(abs(hours))"
}

func formattedCurrentTimeZone(from gmt: Int) -> String {
        let hours = gmt / 3600
    
        let sign = (hours >= 0) ? "+" : "-"
    
        return "GMT\(sign)\(String(format: "%02d", abs(hours))):00"
}

func formattedWorldClock(offset localGMT: Int64) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let currentGMT = TimeZone.current.secondsFromGMT()
    let gmtDifference = localGMT - Int64(currentGMT)
    
    let localDate = Date().addingTimeInterval(TimeInterval(gmtDifference))
    return formatter.string(from: localDate)
}

func formattedTimeDifference(offset localGMT: Int64) -> String {
    let currentGMT = TimeZone.current.secondsFromGMT()
    let gmtDifference = localGMT - Int64(currentGMT)
    var mins: Int64 = 0
    
    if gmtDifference != 0 {
        mins = gmtDifference / 60
    }
    
    
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.zeroFormattingBehavior = .dropAll
    
    if mins < 0 {
        formatter.unitsStyle = .full
    }else {
        formatter.unitsStyle = .short
    }
   
    
    let formattedString = formatter.string(from: abs(Double(gmtDifference)))?.replacingOccurrences(of: ",", with: "") ?? ""
    
    if gmtDifference > 0 {
        return "\(formattedString) ahead"
    } else if gmtDifference < 0 {
        return "\(formattedString) behind"
    } else {
        return "Same as local time"
    }
}




