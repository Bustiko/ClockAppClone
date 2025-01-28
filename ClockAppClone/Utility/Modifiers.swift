//
//  Modifiers.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 9.08.2024.
//

import SwiftUI


struct ButtonTextFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 130, height: 50, alignment: .center)
    }
}

struct AlarmTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35, weight: .regular, design: .default))
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.accentColor)
    }
}
