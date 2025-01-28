//
//  PickerView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 4.08.2024.
//

import SwiftUI


struct PickerView: View {
    @Binding var selection: Int?
    let title: String
    let maxNumber: Int
    private let itemHeight: CGFloat = 40.0
    private let spacing: CGFloat = 15
    private let itemsToShow: CGFloat = 3

    
    var body: some View {

        VStack {
            Text(title)
                .font(.footnote)
            
            ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        ForEach(0...maxNumber, id: \.self) { i in
                            let indexDiff = Double(i - (selection ?? 0))
                            let isInsideRectangle = abs(indexDiff) < 0.5
                            Text("\(String(format: "%02i", i))")
                                .font(.system(size: itemHeight))
                                .foregroundStyle(isInsideRectangle ? Color.accentColor : Color.accentColor.opacity(0.5))
                                .fontWeight(.bold)
                                .id(i)
                                .frame(height: itemHeight)
                            
                        }
                    }
                    .scrollTargetLayout()
                   
            }
            .frame(height: itemsToShow*itemHeight + (itemsToShow-1)*spacing)
            .overlay(alignment: .center) {
                Rectangle()
                    .fill(.clear)
                    .stroke(Color.black.opacity(0.05), lineWidth: 2)
                    .shadow(radius: 12)
                    .frame(height: itemHeight)
                    
                    
            }
            .scrollPosition(id: $selection, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            
            
        }
    }
}

#Preview {
    return PickerView(selection: .constant(100), title: "Hours", maxNumber: 100)
}
