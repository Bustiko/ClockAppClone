//
//  DatePickerView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 7.08.2024.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var date: Date
    @Binding var isSelfPresented: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $date,
                    displayedComponents: .date
                )
                .padding()
                .datePickerStyle(GraphicalDatePickerStyle())
                
                HStack(spacing: 30) {
                    Button(action: {
                        isSelfPresented = false
                    }, label: {
                        Text("Cancel")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    })
                    .padding()
                    Divider()
                        .frame(width: 1, height: 20)
                    Button(action: {
                        isSelfPresented = false
                    }, label: {
                        Text("Save")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    })
                    .padding()
                }//: HSTACK
                .padding(.vertical)
            
            }
            .background(
                Rectangle()
                .fill(Color.colorBrownDark)
                .clipShape(.rect(cornerRadius: 20))
            )
            .padding()
            
                
        }.background(Color.clear)
        
    }
}

#Preview {
    return DatePickerView(date: .constant(Date()), isSelfPresented: .constant(false))
}
