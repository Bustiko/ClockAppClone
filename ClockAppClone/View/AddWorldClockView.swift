//
//  AddWorldClockView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 11.08.2024.
//

import SwiftUI

struct AddWorldClockView: View {
    @StateObject var timezoneManager = TimezoneManager()
    @State private var searchedText = ""
    @State private var isSearchbarPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [], animation: .default)
    private var worldClocks: FetchedResults<WorldTime>
    
    var searchResults: [Zone] {
        if searchedText.isEmpty {
            return timezoneManager.timezoneData.zones
        } else {
            return timezoneManager.timezoneData.zones.filter { zone in
                let startIndex = zone.zoneName.index(after: zone.zoneName.lastIndex(of: "/")!)
                let name = String(zone.zoneName[startIndex...] + " / \(zone.countryName)")
                    .replacingOccurrences(of: "_", with: " ")
                    .replacingOccurrences(of: "-", with: " ")
                return name.contains(searchedText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(searchResults, id: \.zoneName) { zone in
                HStack {
                    VStack(alignment: .leading) {
                        let startIndex = zone.zoneName.index(after: zone.zoneName.lastIndex(of: "/")!)
                        let name = String(zone.zoneName[startIndex...] + " / \(zone.countryName)")
                            .replacingOccurrences(of: "_", with: " ")
                            .replacingOccurrences(of: "-", with: " ")
                        
                        Text(name)
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                        
                        Text("\(formattedTimeZone(from: Int(zone.gmtOffset)))")
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "plus.circle.fill")
                            .onTapGesture(perform: {
                                addItem(zone)
                                dismiss()
                            })
                    })
                }
            }
            .onAppear {
                if timezoneManager.timezoneData.zones.isEmpty {
                    Task {
                        await timezoneManager.fetchData()
                    }
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 20) {
                        Image(systemName: "chevron.left")
                            .onTapGesture(perform: {
                                dismiss()
                            })
                        Text("Add city")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
            .foregroundStyle(Color.accentColor)
        }
        .searchable(text: $searchedText, isPresented: $isSearchbarPresented, prompt: "City/country/region")
    }
    
    private func addItem(_ zone: Zone) {
        if worldClocks.contains(where: { worldTime in
            worldTime.zoneName == zone.zoneName
        }){
            return
        }
            let newItem = WorldTime(context: viewContext)
            newItem.time = zone.timestamp
            newItem.zoneName = zone.zoneName
            newItem.offset = zone.gmtOffset

            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
    }
}

#Preview {
    AddWorldClockView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
