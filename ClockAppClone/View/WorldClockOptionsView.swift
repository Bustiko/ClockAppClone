//
//  WorldClockOptionsView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import SwiftUI

struct WorldClockOptionsView: View {
    @FetchRequest(sortDescriptors:[], animation: .default) private var worldClocks: FetchedResults<WorldTime>
    
    @Binding var isWorldClockOptionsPresented: Bool
    
    @EnvironmentObject private var worldClockEdit: WorldClockEdit
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
         
            if !worldClocks.isEmpty {
                Text("Edit clocks")
                    .fontWeight(.semibold)
                    .onTapGesture(perform: {
                        worldClockEdit.inEditMode = true
                        isWorldClockOptionsPresented = false
                    })
            }else {
                Text("No clock to edit")
            }
            
            
            Button {
                isWorldClockOptionsPresented = false
            } label: {
                Text("Cancel")
            }

        }
        .padding(.horizontal, 30)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.colorGray)
        )
        
    }
}

#Preview {
    return WorldClockOptionsView(isWorldClockOptionsPresented: .constant(false))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
       .environmentObject(WorldClockEdit())
}
