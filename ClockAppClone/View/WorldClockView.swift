//
//  WorldClockView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 4.08.2024.
//

import SwiftUI

struct WorldClockView: View {
    
    let worldClock: WorldTime
    
    @EnvironmentObject private var worldClockEdit: WorldClockEdit
    @Binding var selectedClocks: Set<String>
    @Binding var isAllSelected: Bool
    
    @FetchRequest(
        sortDescriptors: [], animation: .default)
    private var worldClocks: FetchedResults<WorldTime>
    
    private var city: String {
        let startIndex = worldClock.zoneName!.index(after: worldClock.zoneName!.lastIndex(of: "/")!)
        let name = String(worldClock.zoneName![startIndex...])
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
        return name
    }
    
    var body: some View {
        HStack(spacing: 30) {
            if worldClockEdit.inEditMode {
                Toggle(isOn: Binding<Bool>(get: {
                    selectedClocks.contains(worldClock.zoneName!)
                }, set: { isSelected in
                    if isSelected {
                        selectedClocks.insert(worldClock.zoneName!)
                        if selectedClocks.count == worldClocks.count {
                            isAllSelected = true
                        }
                    }else {
                        selectedClocks.remove(worldClock.zoneName!)
                        isAllSelected = false
                    }
                }), label: {})
                    .toggleStyle(CustomToggle())
            }
            VStack(alignment: .leading, spacing: 5, content: {
               
                Text(city)
                    .font(.title2)
                
                Text(formattedTimeDifference(offset: worldClock.offset))
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
            })//: VSTACK
            
            Spacer()
            
            Text(formattedWorldClock(offset: worldClock.offset))
                .font(.largeTitle)
            
            
        }//: HSTACK
        .onChange(of: isAllSelected, {
            if isAllSelected {
                selectedClocks = Set(worldClocks.compactMap({ timezone in
                    timezone.zoneName
                }))
            }else {
                if selectedClocks.count == worldClocks.count {
                    selectedClocks.removeAll()
                }
            }
        })
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    Color.colorBrownDark
                )
            
        )
    }
}

#Preview {
    let clock = WorldTime(context: PersistenceController.preview.container.viewContext)
    clock.zoneName = "Continent/City"
    return WorldClockView(worldClock: clock, selectedClocks: .constant(Set<String>()), isAllSelected: .constant(false))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(WorldClockEdit())
}
