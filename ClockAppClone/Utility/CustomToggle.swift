//
//  CustomToggle.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 18.08.2024.
//

import SwiftUI

struct CustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(configuration.isOn ? Color.accentColor : Color.gray)
                .imageScale(.large)
        }
        .buttonStyle(PlainButtonStyle())

    }
}
