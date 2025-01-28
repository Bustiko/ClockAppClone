//
//  WorldClockEditButtonsView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import SwiftUI

struct WorldClockEditButtonsView: View {
    @EnvironmentObject var worldClockEdit: WorldClockEdit
    @Binding var isDeleteTapped: Bool
    var body: some View {
        HStack {
            Button(action: {
                worldClockEdit.inEditMode = false
            }, label: {
                VStack {
                    Image(systemName: "return.right")
                    Text("Cancel")
                        .font(.footnote)
                        
                }
                
            })
            Spacer()
            Button(action: {
                isDeleteTapped = true
                worldClockEdit.inEditMode = false
            }, label: {
                VStack {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        
                    Text("Delete")
                        .font(.footnote)
                       
                }
                
            })
            
           
        }
        .foregroundStyle(Color.accentColor)
        .padding()
    }
}

#Preview {
    return WorldClockEditButtonsView(isDeleteTapped: .constant(false))
        .environmentObject(WorldClockEdit())
}
