//
//  TabItemView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI

struct TabItemView: View {
    
    @Binding var currentTab: Int
    @State private var isAnimating: Bool = false
    
    let index: Int
    let tabName: String
    
    var body: some View {
        Button(action: {
            currentTab = index
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnimating = false
                }
               
            }
        
        }, label: {
            VStack(spacing: 0) {
                Text(tabName)
                    .font(.system(.headline, design: .default, weight: .semibold))
                    .foregroundStyle((currentTab == index) ? Color.accentColor : Color.gray)
                    .background(
                        (currentTab == index) ?
                        Color.accentColor
                            .frame(height: 2)
                            .clipShape(.capsule)
                            .offset(y: 12)
                        :
                        Color.clear
                            .frame(height: 2)
                            .clipShape(.capsule)
                            .offset(y: 12)
                    )
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 6)
            .background(
                Capsule()
                    .fill(Color.gray.opacity( isAnimating ? 0.3: 0))
                    .scaleEffect(isAnimating ? 1.1 : 1)
            )
                        
        })
        
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TabItemView(currentTab: .constant(0), index: 0, tabName: "Alarm")
        .padding()
}
