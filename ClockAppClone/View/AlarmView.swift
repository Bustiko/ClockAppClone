//
//  CustomToggleButtonView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI
import CoreData

struct AlarmView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.time, ascending: true)],
        animation: .default)
    private var alarms: FetchedResults<Alarm>
    
    @State private var buttonOffset: CGFloat = 0
    @State private var isOn: Bool = false
    @State private var isEnded: Bool = true
    
    @Binding var remainingTime: TimeInterval

    let alarm: Alarm
    
    @EnvironmentObject private var alarmEdit: AlarmEdit
    @Binding var selectedAlarms: Set<Alarm>
    @Binding var isAllSelected: Bool
    
    func updateItem() {
        alarm.isOn = isOn
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func calculateTimeRemaining() {
        if let nextAlarm = alarms.filter({ $0.isOn }).min(by: { $0.time! < $1.time! }) {
            remainingTime = nextAlarm.time!.timeIntervalSinceNow
        } else {
            remainingTime = 0
        }
    }

    var body: some View {
        HStack(spacing: 30) {
            if alarmEdit.inEditMode {
                Toggle(isOn: Binding<Bool>(get: {
                    selectedAlarms.contains(alarm)
                }, set: { isSelected in
                    if isSelected {
                        selectedAlarms.insert(alarm)
                        if selectedAlarms.count == alarms.count {
                            isAllSelected = true
                        }
                    }else {
                        selectedAlarms.remove(alarm)
                        isAllSelected = false
                    }
                }), label: {})
                    .toggleStyle(CustomToggle())
            }
            Text("\(timeFormatter.string(from: alarm.time ?? Date()))")
                .font(.largeTitle)
                .foregroundStyle(Color.gray)

            Spacer()

            Text("\(dateFormatter.string(from: alarm.time ?? Date()))")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(Color.gray)

            VStack {
                if !alarmEdit.inEditMode {
                    ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.accentColor.opacity(Double((buttonOffset + 5) / 15)))
                        .frame(width: 35, height: 20)

                    Circle()
                        .overlay(
                            Circle()
                                .frame(width: 35, height: 40)
                                .opacity(isEnded ? 0 : 0.3)
                                .animation(.easeInOut, value: isEnded)
                        )
                        .scaleEffect(isEnded ? 1 : 0.95)
                        .frame(width: 12, height: 12)
                        .offset(x: buttonOffset + 2)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    isEnded = false
                                    let translation = gesture.translation.width
                                    buttonOffset = min(max(translation, 2), 18)
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut) {
                                        isOn = buttonOffset > 9
                                        buttonOffset = isOn ? 18 : 2
                                        isEnded = true
                                        updateItem()
                                    }
                                }
                        )
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    withAnimation(.linear(duration: 0.35)) {
                                        isOn.toggle()
                                        buttonOffset = isOn ? 18 : 2
                                        isEnded = false
                                        updateItem()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                        isEnded = true
                                    }
                                }
                        )
                    }
                }
            }
        }
        .onChange(of: alarmEdit.inEditMode, {
            buttonOffset = alarm.isOn ? 18 : 2
            isAllSelected = false
        })
        .onChange(of: isAllSelected, {
            if isAllSelected {
                selectedAlarms = Set(alarms)
            }else {
                if selectedAlarms.count == alarms.count {
                    selectedAlarms.removeAll()
                }
            }
        })
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.colorBrownDark)
        )
        .onAppear {
            buttonOffset = alarm.isOn ? 18 : 2
            calculateTimeRemaining()
        }
        .onChange(of: isOn) {
            calculateTimeRemaining()
        }
    }

    
}


#Preview(traits: .sizeThatFitsLayout) {
    let alarm = Alarm(context: PersistenceController.preview.container.viewContext)
    alarm.time = Date()
    alarm.isOn = true
    
    return AlarmView(
        remainingTime: .constant(0),
        alarm: alarm,
        selectedAlarms: .constant(Set<Alarm>()),
        isAllSelected: .constant(false)
    )
    .padding()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AlarmEdit())
}
