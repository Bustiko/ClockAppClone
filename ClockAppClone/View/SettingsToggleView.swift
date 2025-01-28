//
//  SettingsToggleView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 7.08.2024.
//

import SwiftUI

struct SettingsToggleView: View {
    @State private var buttonOffset: CGFloat = 0
    @State private var isOn: Bool = false
    @State private var isEnded: Bool = true
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 30) {
            VStack(alignment: .leading) {
                Text(title)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.accentColor)
                
            }
    
            Spacer()
        
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.accentColor.opacity(Double((buttonOffset+5) / 15)))
                    .frame(width: 35, height: 20)
                
                
                
                Circle()
                    .overlay(
                        Circle()
                            .frame(width: 25, height: 30)
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
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    isEnded = true
                                }
                            }
                    )
                
            }//: ZSTACK
        }//: HSTACK

       
        
    }
}

#Preview {
    SettingsToggleView(title: "Alarm sound", subtitle: "Homecoming")
}
