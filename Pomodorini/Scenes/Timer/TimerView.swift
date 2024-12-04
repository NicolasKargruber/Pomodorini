//
//  Untitled.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

struct TimerView: View {
    let totalDuration: Int // In Seconds
    
    @State private var buttonScale = 1.0
    @State private var elapsedTime = 0  // Track time in seconds
    @State private var isTimerRunning = false
    @State private var shouldResetTimer = false

    @State var pomodorinoCount = 0
    // @State var viewModel: ViewModel
    
    init(duration: Int = 25 * 60) {
        self.totalDuration = duration
        //self.viewModel = ViewModel(seconds: duration)
    }
    
    var isRipe: Bool {
        return elapsedTime >= totalDuration
    }
    
    var formattedTotalTime: String {
        String(format: "%02d:%02d", totalDuration / 60, totalDuration % 60)
    }
    
    var formattedTime: String {
        String(format: "%02d:%02d", elapsedTime / 60, elapsedTime % 60)
    }
    
    var pomdoroRipeness: Double {
        Double(elapsedTime) / Double(totalDuration)
    }
    
    var pomodoroColor: Color {
        try! PomodorinoGradient.color(for: pomdoroRipeness)
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {
                
                // Background Color
                pomodoroColor.ignoresSafeArea().overlay {
                    // Pomodorino Hat
                    Image("Pomodorini_Hat").offset(x: 90, y: -320)
                }
                
                // Content
                VStack {
                    Button("\(pomodorinoCount) 🍅", action: {})
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .buttonStyle(.bordered).tint(.white).frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(){
                        VStack(alignment: .trailing) {
                            Text("Goal: \(formattedTotalTime)")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white).padding(.horizontal, 8)
                            
                            Text(formattedTime)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            self.startTimer()
                            buttonScale = 0.4
                        }) {
                            if buttonScale == 1 && !isRipe {Text("Start")}
                            else if isRipe {
                                NavigationLink(destination: BreakView(/*duration: 10,*/ /*pomodoro: Pomodoro(ripeness: pomdoroRipeness, size: totalDuration),*/ pomodorinoCount: $pomodorinoCount, shouldResetTimer: $shouldResetTimer).navigationBarBackButtonHidden(true)){
                                    Image(systemName: "apple.meditate").scaleEffect(1.5)}
                            }
                            else {}
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(.white))
                        .background(Color(.white).opacity(0.3))
                        .clipShape(Circle())
                        .padding(.all, 3)
                        .overlay(
                            Circle()
                                .stroke(Color(.white)
                                    .opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(isRipe ?  1.4 : buttonScale)
                        .animation(.easeIn, value: isRipe ?  1.4 : buttonScale)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding()
                
            }
            .onDisappear { isTimerRunning = false }
            
        }.onChange(of: shouldResetTimer, initial: false) { _, newValue in
            if(newValue)
            {
                elapsedTime = 0
                startTimer()
                self.shouldResetTimer = false
            }
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {timer in
                
                if self.isTimerRunning {
                    self.elapsedTime += 1 // +1 Second
                    if self.elapsedTime >= totalDuration { // 25 min
                        timer.invalidate()
                        isTimerRunning = false
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
}

#Preview() {
    TimerView(duration: 60)
}

