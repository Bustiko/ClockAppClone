//
//  AlarmEditButtonsView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 19.08.2024.
//

import SwiftUI

struct AlarmEditButtonsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var alarmEdit: AlarmEdit
    @Binding var selectedAlarms: Set<Alarm>
    
    func deleteItem(in alarms: Set<Alarm>) {
        for alarm in alarms {
            viewContext.delete(alarm)
        }
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func switchToggle(in alarms: Set<Alarm>, toBe isOn: Bool) {
        for alarm in alarms {
                alarm.isOn = isOn
        }
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
            HStack {
                Button(action: {
                    alarmEdit.inEditMode = false
                }, label: {
                    VStack {
                        Image(systemName: "return.right")
                            .imageScale(.large)
                        Text("Cancel")
                            .font(.footnote)
                            
                    }
                    
                })
                Spacer()
                
                if (selectedAlarms.contains {$0.isOn}) {
                    VStack {
                        Image(systemName: "alarm")
                            .imageScale(.large)
                        Text("Turn off")
                            .font(.footnote)
                    }
                    .onTapGesture {
                        switchToggle(in: selectedAlarms, toBe: false)
                        alarmEdit.inEditMode = false
                    }
                }
                if (selectedAlarms.contains {$0.isOn}) && (selectedAlarms.contains {!$0.isOn}) {
                    Spacer()
                }
                if (selectedAlarms.contains {!$0.isOn}) {
                    VStack {
                        Image(systemName: "alarm.waves.left.and.right")
                            .imageScale(.large)
                        Text("Turn on")
                            .font(.footnote)
                    }
                    .onTapGesture {
                        switchToggle(in: selectedAlarms, toBe: true)
                        alarmEdit.inEditMode = false
                    }
                }
                   
                Spacer()
               
                Button(action: {
                    deleteItem(in: selectedAlarms)
                    alarmEdit.inEditMode = false
                }, label: {
                    VStack {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            
                        Text("Delete")
                            .font(.footnote)
                           
                    }
                    
                })
                
               
            }
            .foregroundStyle(Color.accentColor)
            .padding()
    }
}

#Preview {
    return AlarmEditButtonsView(selectedAlarms: .constant(Set<Alarm>()))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      .environmentObject(AlarmEdit())
    
}
