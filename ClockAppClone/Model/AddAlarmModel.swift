//
//  AddAlarmModel.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.08.2024.
//

import SwiftUI
import CoreData

class AddAlarmModel: ObservableObject {
    
    private var viewContext: NSManagedObjectContext?
    private var alarms: FetchedResults<Alarm>?
    
    @Published var hours: Int? = 1
    @Published var minutes: Int? = 1
    @Published var isDatePickerPresented: Bool = false
    
    @Binding var date: Date
    
    var maxTimeElement: (hour: Int, min: Int) {
        (hour: 23, min: 59)
    }
    

    init(date: Binding<Date>) {
        self._date = date
    }
    
    func configure(viewContext: NSManagedObjectContext, alarms: FetchedResults<Alarm>) {
        self.viewContext = viewContext
        self.alarms = alarms
    }
    
    func addItem() {
        withAnimation {
            if date <= Date.now {
                if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) {
                    date = nextDay
                }
            }
            
            if let alarms = alarms, let viewContext = viewContext {
                if alarms.contains(where: { alarm in
                    alarm.time == date
                }){
                    return
                }
                
                let newItem = Alarm(context: viewContext)
                newItem.time = date
                newItem.isOn = true
                
                do {
                    try viewContext.save()
                } catch {
                    print("couldn't save")
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func createAndAddAlarm() {
            if let hour = hours, let minute = minutes {
                if let newDate = DateUtility.createDateWith(hour: hour, minute: minute, from: date) {
                    date = newDate
                    addItem()
                    date = Date()
                }
            }
        }
}
