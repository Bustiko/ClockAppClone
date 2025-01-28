//
//  TimerProgressView.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 9.08.2024.
//

import SwiftUI


struct TimerProgressView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var hour: Int?
    @Binding var minute: Int?
    @Binding var second: Int?
    
    @State private var totalSeconds: Int = 0
    @State private var timer: Timer?
    @State private var didStart: Bool = true
    @State private var progress: CGFloat = 1
    
    @State private var didAppear: Bool = false
    
    private var progressInSeconds: CGFloat {
        CGFloat(totalSeconds)
    }
    
  
    func createTimeInSeconds(hour: Int, minute: Int, second: Int) {
        totalSeconds = hour * 3600 + minute * 60 + second
    }
    
    func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if progress != 0 {
                progress -= 1/progressInSeconds
                totalSeconds = totalSeconds - 1
            }else{
                timer?.invalidate()
            }
            
        }
    }
    
    func formatTimeComponent(_ value: Int, unit: String) -> String? {
        return value > 0 ? "\(value) \(unit)" : nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .center) {
                    Group {
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 15)
                            .padding()
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.colorAccentDark, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                            .padding()
                            .rotationEffect(.degrees(-90))
                    }
                    .padding(20)
                    
                    if let hour = hour, let minute = minute, let second = second {
                        VStack {
                            let formattedTime = [
                                formatTimeComponent(hour, unit: "h"),
                                formatTimeComponent(minute, unit: "m"),
                                formatTimeComponent(second, unit: "s")
                            ].compactMap({ $0 }).joined(separator: " ")
                            
                            Text("\(formattedTime)")
                                .offset(y: -30)
                                .fontWeight(.semibold)
                            
                            Text("\(formattedTimer(totalSeconds: totalSeconds))")
                                .monospacedDigit()
                                .font(.system(size: 60))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accentColor)
                                .onAppear(perform: {
                                    createTimeInSeconds(hour: hour, minute: minute, second: second)
                                })
                            
                            
                            HStack {
                                Image(systemName: "bell.fill")
                                Text(timeFormatter.string(from: Date.now + progressInSeconds))
                                    .fontWeight(.semibold)
                            }
                            
                            .offset(y: 30)
                            
                        }//: VSTACK
                        .foregroundStyle(Color.accentColor)
                        
                    }
                }//: ZSTACK
                .opacity(didAppear ? 1 : 0)
                .scaleEffect(didAppear ? 1 : 0, anchor: .center)
                .animation(.easeInOut(duration: 0.5), value: didAppear)
                
                Spacer()
                HStack(spacing: 30) {
                    
                    Button(action: {
                        timer?.invalidate()
                        didAppear = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                        
                       
                    }, label: {
                        Text("Delete")
                            .modifier(ButtonTextFrameModifier())
                            .fontWeight(.semibold)
                        
                    })
                    .background(Capsule().fill(Color.gray.opacity(0.3)))
                    
                    
                    
                    
                    Button(action: {
                        
                        didStart.toggle()
                        
                        if didStart {
                            startCountdown()
                        }else {
                            timer?.invalidate()
                        }
                        
                    }, label: {
                        Text(didStart ? "Pause" : "Start")
                            .modifier(ButtonTextFrameModifier())
                            .fontWeight(.semibold)
                        
                    })
                    .background(Capsule().fill(didStart ? Color.red : Color.accentColor))
                    
                    
                }
                .foregroundStyle(Color.white)
                .padding(.bottom, 50)
            }//: VSTACK
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "list.dash")
                        Image(systemName: "plus")
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                    .foregroundStyle(Color.accentColor)
                }
            })
        }//: NAVIGATION
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                didAppear = true
                startCountdown()
            }
                
        })
        
        
    }
}

#Preview {
    return TimerProgressView(hour: .constant(1), minute: .constant(30), second: .constant(25))
}
