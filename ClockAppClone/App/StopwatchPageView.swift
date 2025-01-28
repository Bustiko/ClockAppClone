//
//  StopwatchPageView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 3.08.2024.
//

import SwiftUI

struct StopwatchPageView: View {
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    @State private var didStart: Bool = false
    @State private var didReset: Bool = true
    
    private var isButtonDisabled: Bool {
        return didStart||didReset ? true : false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1/12, repeats: true) { _ in
 
                if didStart {
                    elapsedTime += 1/12
                }else {
                    return
                }
                
            
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                Text(stopwatchFormatter.string(from: Date(timeIntervalSinceReferenceDate: elapsedTime)))
                    .font(.system(size: 55))
                    .monospacedDigit()
                    .foregroundStyle(Color.accentColor)
                    .offset(y: 60)
                
                
                
                
                Spacer()
                HStack(spacing: 30) {
                    Button(action: {
                        didReset = true
                        elapsedTime = 0
                        timer?.invalidate()
                    }, label: {
                        Text("Reset")
                            .foregroundStyle(isButtonDisabled ? Color.gray: Color.white)
                            .modifier(ButtonTextFrameModifier())
                            .background(Capsule()
                                .fill(
                                    Color.gray.opacity(
                                        isButtonDisabled ? 0 : 0.2)
                                )
                            )
                    })
                    .disabled(isButtonDisabled)
                    
                    Button(action: {
                        if !didStart {
                            didReset = false
                            didStart.toggle()
                            startTimer()
                        } else {
                            didStart.toggle()
                            timer?.invalidate()
                        }
                    }, label: {
                        Text(didStart ? "Stop" : "Start")
                            .foregroundStyle(Color.white)
                            .modifier(ButtonTextFrameModifier())
                            .background(Capsule().fill(didStart ? Color.red : Color.colorPurple))
                    })
                }
                .padding(.bottom, 50)
                
                
                
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }
}

#Preview {
    StopwatchPageView()
}
