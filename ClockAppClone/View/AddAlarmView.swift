//
//  AddClockView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 7.08.2024.
//

import SwiftUI

struct AddAlarmView: View {
    @StateObject private var viewModel: AddAlarmModel
    
    @Environment(\.managedObjectContext) private var viewContext
       @FetchRequest(
           sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.time, ascending: true)],
           animation: .default)
       private var alarms: FetchedResults<Alarm>
    
    @Environment(\.dismiss) private var dismiss
    
    init(date: Binding<Date>) {
        _viewModel = StateObject(wrappedValue: AddAlarmModel(date: date))
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    PickerSection(title: "", selection: $viewModel.hours, maxNumber: viewModel.maxTimeElement.hour)
                    VStack {
                        Rectangle()
                            .frame(width: 0, height: 30)
                        Text(":")
                            .font(.system(size: 50, weight: .bold, design: .default))
                        Rectangle()
                            .frame(width: 0, height: 25)
                    }
                    PickerSection(title: "", selection: $viewModel.minutes, maxNumber: viewModel.maxTimeElement.min)
                }
                .padding(.horizontal, 30)
                
                VStack(alignment: .center, spacing: 30) {
                    HStack(alignment: .center) {
                        Text("S").foregroundStyle(Color.red)
                        Spacer()
                        Text("M")
                        Spacer()
                        Text("T")
                        Spacer()
                        Text("W")
                        Spacer()
                        Text("T")
                        Spacer()
                        Text("F")
                        Spacer()
                        Text("S").foregroundStyle(Color.red)
                    }
                    .padding(.vertical)
                    
                    SettingsToggleView(title: "Alarm sound", subtitle: "Homecoming")
                    Divider()
                    SettingsToggleView(title: "Vibration", subtitle: "Basic call")
                    Divider()
                    SettingsToggleView(title: "Snooze", subtitle: "5 minutes, 3 times")
                }
                .overlay(alignment: .topTrailing) {
                    Button(action: {
                        viewModel.isDatePickerPresented = true
                    }, label: {
                        Image(systemName: "calendar")
                            .offset(x: 5, y: -20)
                            .foregroundStyle(Color.white)
                    })
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(Color.colorBrownDark.clipShape(.rect(cornerRadius: 20)))
                .padding(.vertical, 30)
                
                Spacer()
                HStack(spacing: 30) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(.title2)
                            .fontWeight(.bold)
                    })
                    .padding()
                    
                    Button(action: {
                        viewModel.createAndAddAlarm()
                        dismiss()
                    }, label: {
                        Text("Save")
                            .font(.title2)
                            .fontWeight(.bold)
                    })
                    .padding()
                }
                .padding(.vertical)
            }
            
            if viewModel.isDatePickerPresented {
                BlankView()
                    .onTapGesture {
                        viewModel.isDatePickerPresented = false
                    }
                
                DatePickerView(date: $viewModel.date, isSelfPresented: $viewModel.isDatePickerPresented)
            }
        }
        .onAppear(perform: {
            viewModel.configure(viewContext: viewContext, alarms: alarms)
        })
    }
}

#Preview {
    return AddAlarmView(date: .constant(Date()))
}
