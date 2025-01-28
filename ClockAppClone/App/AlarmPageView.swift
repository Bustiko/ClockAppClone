//
//  ContentView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.07.2024.
//

import SwiftUI
import CoreData

struct AlarmPageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.time, ascending: true)],
        animation: .default)
    private var alarms: FetchedResults<Alarm>

    @State private var date: Date = Date()
    @State private var isAddAlarmPresented: Bool = false
    @State private var remainingTime: TimeInterval = 0
    
    @State private var isAlarmOptionsPresented: Bool = false
    @EnvironmentObject private var alarmEdit: AlarmEdit
    @State private var isAllSelected: Bool = false
    @State private var selectedAlarms: Set<Alarm> = []


    var body: some View {
        VStack {
            VStack {
                if alarmEdit.inEditMode {
                    let message = selectedAlarms.count > 0
                        ? "\(selectedAlarms.count) selected"
                        : "Select alarms"
                    
                    Text(message)
                        .modifier(AlarmTitleModifier())
                    
                } else {
                    if alarms.isEmpty {
                        Text("Alarm")
                            .modifier(AlarmTitleModifier())
                    }else{
                        Text("\(alarmFormattedRemainingTime(remainingTime: remainingTime))")
                            .modifier(AlarmTitleModifier())
                           
                        Text("\(alarmFormattedDate(remainingTime: remainingTime))")
                            .font(.footnote)
                            .foregroundStyle(Color.gray)
                    }
                   
                }
                   
            } //: VSTACK
            .padding(.top, 35)
            .padding(.bottom, 20)

            NavigationStack {
                ScrollView {
                    if !alarms.isEmpty {
                        VStack {
                            ForEach(alarms) { alarm in
                                AlarmView(
                                    remainingTime: $remainingTime,
                                    alarm: alarm,
                                    selectedAlarms: $selectedAlarms,
                                    isAllSelected: $isAllSelected
                                )
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                            }//: LOOP
                        }
                    } else {
                            Text("No alarms")
                                .font(.title2)
                                .foregroundStyle(Color.accentColor)
                                .padding()
                      
                    }//: VSTACK
                }//: SCROLL
                .toolbarBackground(.black, for: .navigationBar)
                .toolbar {
                    if alarmEdit.inEditMode {
                        ToolbarItem(placement: .topBarLeading) {
                            VStack {
                                Toggle(isOn: $isAllSelected, label: {})
                                    .toggleStyle(CustomToggle())
                                
                                Text("All")
                                    .font(.footnote)
                            }
                            .foregroundStyle(Color.accentColor)
                            
                        }
                    }else  {
                        ToolbarItem(placement: .topBarTrailing) {
                                HStack {
                                    Button(action: {
                                        isAddAlarmPresented = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
                                    .fullScreenCover(isPresented: $isAddAlarmPresented, content: {
                                        AddAlarmView(date: $date)
                                    })

                                    Button(action: {
                                        isAlarmOptionsPresented = true
                                    }, label: {
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                    })
                                }//: HSTACK
                        }
                    }
                   
                }//: TOOLBAR
                Spacer()
            }//: NAVIGATION
            .overlay(alignment: .topTrailing) {
                if isAlarmOptionsPresented {
                    AlarmOptionsView(isAlarmOptionsPresented: $isAlarmOptionsPresented)
                }
            }
            
            if alarmEdit.inEditMode && !selectedAlarms.isEmpty {
                AlarmEditButtonsView(selectedAlarms: $selectedAlarms)
            }
        }//: VSTACK
        .onAppear(perform: {
            alarms.forEach { alarm in
                if alarm.time! <= Date() {
                    alarm.isOn = false
                }
            }
            
            do {
                try viewContext.save()
            } catch {
                print("couldn't save")
                print(error)
            }
        })
       
       
    }

}





#Preview {
    AlarmPageView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AlarmEdit())
}
