//
//  TimersView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 6.08.2024.
//

import SwiftUI

struct TimersView: View {
    @FetchRequest(sortDescriptors:[NSSortDescriptor(keyPath: \Chronometer.dateAdded, ascending: true)], animation: .default) private var timers: FetchedResults<Chronometer>
    
    @State var tappedIndex: Int? = nil
    @Binding var toggledIndices: Set<Int>
    let circleSize: CGSize = CGSize(width: 100, height: 100)
    let spacing: CGFloat = 30
    var timersLength: CGFloat {
        let totalCircle = CGFloat(timers.count)
        return ((circleSize.width*totalCircle) + (spacing*(totalCircle+1)))
    }
    
    @Binding var hour: String
    @Binding var minute: String
    @Binding var second: String
    
    
    @State private var isOn: Bool = false

    
    @EnvironmentObject var timerEdit: TimerEdit
    
    @Binding var isAllSelected: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: spacing) {
                        if timers.count < 4 {
                            Spacer(minLength: (geometry.size.width - timersLength) / 2)
                        }
                        
                        ForEach(0..<timers.count, id: \.self) { i in
                            VStack {
                                Text("\(timers[i].hour!):\(timers[i].minute!):\(timers[i].second!)")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                            }
                            .onChange(of: isAllSelected, {
                                if isAllSelected {
                                    toggledIndices = Set(0..<timers.count)
                                }else {
                                    if toggledIndices.count == timers.count {
                                        toggledIndices.removeAll()
                                    }
                                }
                            })
                            .id(timers[i].id)
                            .frame(width: circleSize.width, height: circleSize.height, alignment: .center)
                            .background(
                                Circle()
                                    .stroke((tappedIndex == i) ?
                                            (timerEdit.isInEditMode ? Color.gray : Color.accentColor) : Color.clear, lineWidth: 5)
                                    .fill(
                                        (tappedIndex == i) ? Color.black : Color.gray.opacity(0.25)
                                    )
                                
                            )
                            .allowsHitTesting(!timerEdit.isInEditMode)
                            .onTapGesture {
                                tappedIndex = i
                                hour = timers[i].hour!
                                minute = timers[i].minute!
                                second = timers[i].second!
                            }
                            .overlay(alignment: .topLeading) {
                                if timerEdit.isInEditMode {
                                    Toggle(isOn: Binding<Bool>(get: {
                                        toggledIndices.contains(i)
                                    }, set: { newValue in
                                        if newValue {
                                            toggledIndices.insert(i)
                                            if toggledIndices.count == timers.count {
                                                isAllSelected = true
                                            }
                                        }else {
                                            toggledIndices.remove(i)
                                            isAllSelected = false
                                        }
                                    })) {}
                                    .toggleStyle(CustomToggle())
                                    .offset(x: -10, y: -10)
                                }
                                
                               
                            }

                        }
                        
                        if timers.count < 4 {
                            Spacer(minLength: (geometry.size.width - timersLength) / 2)
                        }
                    }
                    
                    .padding(.vertical)
                    
                    
                }
                .onChange(of: timers.count) {
                    tappedIndex = timers.count - 1
                    
                }
                .scrollDisabled((timers.count < 4) ? true : false)
                .scrollIndicators(.hidden)
                .onChange(of: tappedIndex) {
                    if let index = tappedIndex {
                        if timers.count >= 4 {
                            withAnimation(.default) {
                                
                                proxy.scrollTo(index, anchor: .center)
                                
                            }
                        }
                    }
                }
            }
        }
        .frame(height: circleSize.height)
    }
}


#Preview {
    return TimersView(
        toggledIndices: .constant(Set<Int>()),
        hour: .constant("00"),
        minute: .constant("00"),
        second: .constant("00"),
        isAllSelected: .constant(false)
    )
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(TimerEdit())
}
