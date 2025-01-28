//
//  MainAppView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.07.2024.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentTab: Int = 0
    @EnvironmentObject var timerEdit: TimerEdit
    @EnvironmentObject var alarmEdit: AlarmEdit
    @EnvironmentObject var worldClockEdit: WorldClockEdit
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab,
                    content:  {
                AlarmPageView()
                    .tag(0)
                
                WorldClockPageView()
                    .tag(1)
                
                StopwatchPageView()
                    .tag(2)
                
                
                TimerPageView()
                    .tag(3)
            })
           
            if !timerEdit.isInEditMode && !alarmEdit.inEditMode && !worldClockEdit.inEditMode {
                TabSelectionView(currentTab: $currentTab)
                    .padding(.vertical, 20)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}

#Preview {
    MainAppView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(TimerEdit())
        .environmentObject(AlarmEdit())
        .environmentObject(WorldClockEdit())
}
