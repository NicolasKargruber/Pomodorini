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

    @State var pomodorinoCount = 0
    // @State var viewModel: ViewModel
    
    init(duration: Int = 25 * 60) {
        self.totalDuration = duration
        //self.viewModel = ViewModel(seconds: duration)
    }
    
    var isRipe: Bool {
        return elapsedTime >= totalDuration
    }
    
    var formattedTime: String {
        String(format: "%02d:%02d", elapsedTime / 60, elapsedTime % 60)
    }
    
    var pomdoroRipeness: Double {
        Double(elapsedTime) / Double(totalDuration)
    }
    
    var pomodoroColor: Color {
        PomodoroGradient(at: pomdoroRipeness).getColor()
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    Text(formattedTime)
                        .font(.system(size: 80, weight: .bold))
                        .padding()
                        .foregroundColor(.white)
                    
                    Button(action: {
                        self.startTimer()
                        buttonScale = 0.4
                    }) {
                        if buttonScale == 1 && !isRipe {Text("Start")}
                        else if isRipe {
                            NavigationLink(destination: PlantFarmView(pomodoro: Pomodoro(ripeness: pomdoroRipeness, size: totalDuration))){
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
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(pomodoroColor)
                    .onDisappear {
                        isTimerRunning = false
                    }
            
                
                Image("Pomodorini_Hat")
                    .offset(x: 90, y: -130)
                
                Button("0 🍅", action: {})
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .buttonStyle(.bordered).tint(.white)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 8)
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
    TimerView(duration: 5)
}

