//
//  ClockAppCloneApp.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.07.2024.
//

import SwiftUI

@main
struct ClockAppCloneApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var timerEdit = TimerEdit()
    @StateObject var alarmEdit = AlarmEdit()
    @StateObject var worldClockEdit = WorldClockEdit()

    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerEdit)
                .environmentObject(alarmEdit)
                .environmentObject(worldClockEdit)
        }
    }
}
