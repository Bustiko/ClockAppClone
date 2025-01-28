//
//  WorldClockPageView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI
import CoreData

struct WorldClockPageView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [], animation: .default)
    private var worldClocks: FetchedResults<WorldTime>
    
    @State private var isAddPagePresented: Bool = false
    
    @State private var localClock: Date = Date.now
    @State private var timer: Timer?
    
    @EnvironmentObject private var worldClockEdit: WorldClockEdit
    
    @State private var isWorldClockOptionsPresented: Bool = false
    
    @State private var isAllSelected: Bool = false
    @State private var selectedClocks: Set<String> = []
    @State private var isDeleteTapped: Bool = false
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.localClock += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var body: some View {
        
        
        VStack {
            VStack {
                if worldClockEdit.inEditMode {
                    let message = worldClocks.count > 0
                        ? "\(worldClocks.count) selected"
                        : "Select cities"
                    
                    Text(message)
                        .modifier(AlarmTitleModifier())
                    
                }else {
                    Text("\(timerFormatter.string(from: localClock))")
                        .monospacedDigit()
                        .font(.system(size: 35, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("\(formattedCurrentTimeZone(from: TimeZone.current.secondsFromGMT()))")
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                }
                
            }//: VSTACK
            .padding(.top, 35)
            .padding(.bottom, 20)
           
            
            NavigationStack {
                ScrollView {
                    VStack {
                        ForEach(worldClocks) { clock in
                           
                           WorldClockView(worldClock: clock, selectedClocks: $selectedClocks, isAllSelected: $isAllSelected)
                        }
                       
                    }//: VSTACK
                    .toolbar {
                        if worldClockEdit.inEditMode {
                            ToolbarItem(placement: .topBarLeading) {
                                VStack {
                                    Toggle(isOn: $isAllSelected, label: {})
                                        .toggleStyle(CustomToggle())
                                    
                                    Text("All")
                                        .font(.footnote)
                                }
                                .onAppear(perform: {
                                    isAllSelected = false
                                })
                                .foregroundStyle(Color.accentColor)
                                
                            }
                        }else {
                            ToolbarItem(placement: .topBarTrailing) {
                                HStack {
                                    Button {
                                        isAddPagePresented = true
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .fullScreenCover(isPresented: $isAddPagePresented, content: {
                                        AddWorldClockView()
                                    })

                                    Button(action: {
                                        isWorldClockOptionsPresented = true
                                    }, label: {
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                    })
                                }//: HSTACK
                                
                            } //: TOOLBAR ITEM
                        }
                }//: TOOLBAR
                }//: SCROLL
                Spacer()
            }//: NAVIGATION
            .overlay(alignment: .topTrailing) {
                if isWorldClockOptionsPresented {
                    WorldClockOptionsView(isWorldClockOptionsPresented: $isWorldClockOptionsPresented)
                }
            }
            
            if worldClockEdit.inEditMode && !selectedClocks.isEmpty {
                WorldClockEditButtonsView(isDeleteTapped: $isDeleteTapped)
            }
        }//: VSTACK
        .onChange(of: isDeleteTapped) {
            if isDeleteTapped {
                deleteItems(clocks: selectedClocks)
            }
        }
        .onAppear(perform: {
            startTimer()
        })
        .onDisappear(perform: {
            stopTimer()
        })
    }

    private func deleteItems(clocks: Set<String>) {
            for city in clocks {
                let fetchRequest: NSFetchRequest<WorldTime> = WorldTime.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "zoneName == %@", city)
                
                do {
                    let clocksToDelete = try viewContext.fetch(fetchRequest)
                    for clock in clocksToDelete {
                        viewContext.delete(clock)
                    }
                    
                    try viewContext.save()
                } catch {
                    print("Failed to delete items: \(error.localizedDescription)")
                }
            }
    }

    }


#Preview {
    WorldClockPageView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(WorldClockEdit())
}
