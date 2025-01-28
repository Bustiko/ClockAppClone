//
//  BlankView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 7.08.2024.
//

import SwiftUI

struct BlankView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    BlankView()
}
