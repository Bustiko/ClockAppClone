//
//  TabSelectionView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI

struct TabSelectionView: View {
    
    @Binding var currentTab: Int
  
    
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            TabItemView(currentTab: $currentTab, index: 0, tabName: "Alarm")
            
            TabItemView(currentTab:  $currentTab, index: 1, tabName: "World Clock")
            
            TabItemView(currentTab:  $currentTab, index: 2, tabName: "Stopwatch")
            
            TabItemView(currentTab:  $currentTab, index: 3, tabName: "Timer")
               
        })
       
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TabSelectionView(currentTab: .constant(0))
}
