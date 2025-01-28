//
//  TimerEditButtonsView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 18.08.2024.
//

import SwiftUI

struct TimerEditButtonsView: View {
    @EnvironmentObject var timerEdit: TimerEdit
    @Binding var isDeleteTapped: Bool
    var body: some View {
        HStack {
            Button(action: {
                timerEdit.isInEditMode = false
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
                timerEdit.isInEditMode = false
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
    return TimerEditButtonsView(isDeleteTapped: .constant(false))
}
