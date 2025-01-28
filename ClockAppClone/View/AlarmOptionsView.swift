//
//  AlarmOptionsView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 19.08.2024.
//

import SwiftUI

struct AlarmOptionsView: View {
    @FetchRequest(sortDescriptors:[], animation: .default) private var alarms: FetchedResults<Alarm>
    
    @Binding var isAlarmOptionsPresented: Bool
    
    @EnvironmentObject private var alarmEdit: AlarmEdit
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
         
            if !alarms.isEmpty {
                Text("Edit alarms")
                    .fontWeight(.semibold)
                    .onTapGesture(perform: {
                        alarmEdit.inEditMode = true
                        isAlarmOptionsPresented = false
                    })
            }else {
                Text("No alarms to edit")
            }
            
            
            Button {
                isAlarmOptionsPresented = false
            } label: {
                Text("Cancel")
            }

        }
        .padding(.horizontal, 30)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.colorGray)
        )
        
    }
}

#Preview {
    return AlarmOptionsView(isAlarmOptionsPresented: .constant(false))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AlarmEdit())
}
