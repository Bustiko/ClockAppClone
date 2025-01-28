//
//  AddTimerView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 14.08.2024.
//

import SwiftUI

struct AddTimerView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isAddTimerPresented: Bool
    @Binding var hour: String
    @Binding var minute: String
    @Binding var second: String
    
    @State private var selfHour: String = "00"
    @State private var selfMinute: String = "00"
    @State private var selfSecond: String = "00"
    
    private func addItem() {
        let newItem = Chronometer(context: context)
        newItem.hour = hour
        newItem.minute = minute
        newItem.second = second
        newItem.dateAdded = Date()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Add preset timer")
                        .fontWeight(.semibold)
                    HStack {
                        TextField("", text: $selfHour.max(2, time: Time.hour))
                          
                        Text(":")
                        
                        TextField("", text: $selfMinute.max(2, time: Time.minute))
                        
                        Text(":")
                        
                        TextField("", text: $selfSecond.max(2, time: Time.second))
                           
                        
                    }//: HSTACK
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            
                        }
                    }
                    .tint(.clear)
                    .keyboardType(.numberPad)
                    .font(.title)
                    .fontWeight(.bold)
                    .fixedSize()
                    
                    HStack(spacing: 30) {
                        Spacer()
                        Button(action: {
                            isAddTimerPresented = false
                        }, label: {
                            Text("Cancel")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                        })
                        Divider()
                            .frame(width: 1, height: 12)
                            .background(Color.white)
                        Button(action: {
                            hour = selfHour
                            minute = selfMinute
                            second = selfSecond
                            
                            addItem()
                            isAddTimerPresented = false
                        }, label: {
                            Text("Add")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                        })
                        Spacer()
                    }//: HSTACK
                    .padding(.vertical)
                }//: VSTACK
                Spacer()
            }//: HSTACK
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.colorGray)
            )
        }//: VSTACK
        .padding()
    }
}

#Preview {
    return AddTimerView(isAddTimerPresented: .constant(false), hour: .constant("00"), minute: .constant("00"), second: .constant("00"))
}
