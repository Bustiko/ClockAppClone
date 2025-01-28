//
//  TimerPresetView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 14.08.2024.
//

import SwiftUI

struct TimerPresetView: View {
    @FetchRequest(sortDescriptors:[], animation: .default) private var timers: FetchedResults<Chronometer>
    
    @Binding var isPresetTimerPresented: Bool
    @Binding var isAddTimerPresented: Bool
    
    @EnvironmentObject var timerEdit: TimerEdit
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Add preset timer")
                .fontWeight(.semibold)
                .onTapGesture(perform: {
                    isAddTimerPresented = true
                    isPresetTimerPresented = false
                })
            if !timers.isEmpty {
                Text("Edit preset timers")
                    .fontWeight(.semibold)
                    .onTapGesture(perform: {
                        timerEdit.isInEditMode = true
                        isPresetTimerPresented = false
                    })
            }
            
            
            Button {
                isPresetTimerPresented = false
            } label: {
                Text("Cancel")
            }

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.colorGray)
        )
        
    }
}

#Preview {
    return TimerPresetView(isPresetTimerPresented: .constant(false), isAddTimerPresented: .constant(false))
}
