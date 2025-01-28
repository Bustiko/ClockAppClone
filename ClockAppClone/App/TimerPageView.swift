//
//  TimerPageView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI

struct TimerPageView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors:[], animation: .default) private var timers: FetchedResults<Chronometer>
    
    @State var hours: Int? = 1
    @State var minutes: Int? = 1
    @State var seconds: Int? = 1
    
    @State private var didStart: Bool = false
    @State private var isPresetTimerPresented: Bool = false
    @State private var isAddTimerPresented: Bool = false
    
    
    @EnvironmentObject var timerEdit: TimerEdit
    
    @State private var toggledIndices: Set<Int> = []
    @State private var isDeleteTapped: Bool = false
    
    @State private var selectedTimerIndex: Int? = nil
    
    @State private var isAllSelected: Bool = false
    
    
    
    let maxTimeElement = (hour: 99,minSec: 59)
    
    private var isButtonDisabled: Bool {
        if hours == 0 && minutes == 0 && seconds == 0 {
            return true
        }
        
        return false
        
    }
    
    func deleteItem(in indices: Set<Int>) {
        for i in indices {
            context.delete(timers[i])
        }
        do {
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
        
    }

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                
                    HStack(spacing: 0) {
                        PickerSection(title: "Hours", selection: $hours, maxNumber: maxTimeElement.hour)
                        SeperatorView()
                        PickerSection(title: "Minutes", selection: $minutes, maxNumber: maxTimeElement.minSec)
                        SeperatorView()
                        PickerSection(title: "Seconds", selection: $seconds, maxNumber: maxTimeElement.minSec)
                    }//: HSTACK
                    .padding(30)
                    .disabled(timerEdit.isInEditMode)
                    
                    
                    TimersView(
                        toggledIndices: $toggledIndices, 
                    hour: Binding(
                            get: { String(format: "%02d", hours ?? 0) },
                            set: { hours = Int($0) ?? 0 }
                        ),
                    minute: Binding(
                        get: { String(format: "%02d", minutes ?? 0) },
                        set: { minutes = Int($0) ?? 0 }
                    ),
                    second: Binding(
                        get: { String(format: "%02d", seconds ?? 0) },
                        set: { seconds = Int($0) ?? 0 }
                    ),isAllSelected: $isAllSelected
                    )
                    
                        
                    
                    
                    Spacer()
                   
                
                    Button(action: {
                        didStart = true
                    }, label: {
                        Text("Start")
                            .foregroundStyle(Color.white)
                            .frame(width: 130, height: 50, alignment: .center)
                            .background(Capsule())
                    })
                    .padding(30)
                    .opacity(isButtonDisabled || timerEdit.isInEditMode ? 0.5 : 1)
                    .disabled(isButtonDisabled || timerEdit.isInEditMode)
                    .fullScreenCover(isPresented: $didStart, content: {
                        TimerProgressView(hour: $hours, minute: $minutes, second: $seconds)
                        
                    })
                    
             
                    
                    
                }//: VSTACK
                .toolbar(content: {
                    if timerEdit.isInEditMode {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack(alignment: .top, spacing: 20) {
                                VStack {
                                    Toggle("", isOn: $isAllSelected)
                                        .toggleStyle(CustomToggle())
                                    Text("All")
                                        .font(.footnote)
                                }
                                
                                let message = toggledIndices.count > 0
                                    ? "\(toggledIndices.count) selected"
                                    : "Select presets"

                                Text(message)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                            }
                            .foregroundStyle(Color.accentColor)
                            .padding()
                            
                        }
                        
                        ToolbarItem(placement: .bottomBar) {
                          TimerEditButtonsView(isDeleteTapped: $isDeleteTapped)
                        }
                    }else {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundStyle(Color.accentColor)
                                .onTapGesture(perform: {
                                    isPresetTimerPresented = true
                                })
                        }
                    }
                   
                })//: TOOLBAR
            }//: NAVIGATION
            .onChange(of: isDeleteTapped, {
                if isDeleteTapped {
                    deleteItem(in: toggledIndices)
                }
            })
            .overlay(alignment: .topTrailing,
                     content: {
                if isPresetTimerPresented {
                    TimerPresetView(
                        isPresetTimerPresented: $isPresetTimerPresented,
                        isAddTimerPresented: $isAddTimerPresented
                    )
                }
            })
            
            if isAddTimerPresented {
                BlankView()
                    .onTapGesture(perform: {
                        isAddTimerPresented = false
                        isPresetTimerPresented = false
                    })
                
                AddTimerView(
                    isAddTimerPresented: $isAddTimerPresented,
                    hour: Binding(
                        get: { String(format: "%02d", hours ?? 0) },
                        set: { hours = Int($0) ?? 0 }
                    ),
                    minute: Binding(
                        get: { String(format: "%02d", minutes ?? 0) },
                        set: { minutes = Int($0) ?? 0 }
                    ),
                    second: Binding(
                        get: { String(format: "%02d", seconds ?? 0) },
                        set: { seconds = Int($0) ?? 0 }
                    )
                )
                
                
            }
        }//: ZSTACK
       
    }
}

struct PickerSection: View {
    let title: String
    @Binding var selection: Int?
    let maxNumber: Int

    var body: some View {
        ScrollViewReader { proxy in
            PickerView(selection: $selection, title: title, maxNumber: maxNumber)
                .onAppear {
                    DispatchQueue.main.async {
                        proxy.scrollTo(selection, anchor: .center)
                    }
                }
        }
    }
}

struct SeperatorView: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 0,height: 45)
            Text(":")
                .font(.system(size: 50, weight: .bold, design: .default))
            Rectangle()
                .frame(width: 0,height: 18)
            
        }
    }
}

#Preview {
//    @State var inEditMode: Bool = false
    return TimerPageView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(TimerEdit())
}


