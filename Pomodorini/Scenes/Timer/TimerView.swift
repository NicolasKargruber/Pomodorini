//
//  Untitled.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

struct TimerView: View {
    @State private var buttonScale = 1.0
    @State private var shouldResetTimer = false

    @State var pomodorinoCount = 0
    @State var timerManager: TimerManager
    
    init(durationInMinutes: Int = 25) {
        try! self.timerManager = TimerManager(
            totalMinutes: durationInMinutes, allowOvertime: false)
    }
    
    var isRipe: Bool {
        self.timerManager.isCompleted
    }
    
    var pomdoroRipeness: Double {
        self.timerManager.progress
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
                            
                            Text("Goal: 01:00")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white).padding(.horizontal, 72)
                            
                            Text(timerManager.formattedTime)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white).frame(maxWidth: .infinity)
                            
                        }.frame(maxWidth: .infinity)
                        
                        Button(action: {
                            timerManager.start()
                            buttonScale = 0.4
                                }) {
                            if buttonScale == 1 && !isRipe {Text("Start")}
                            else if isRipe {
                                NavigationLink(
                                    destination: BreakView(durationInMinutes: 1,pomodorinoCount: $pomodorinoCount, shouldResetTimer: $shouldResetTimer).navigationBarBackButtonHidden(true)){
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
            }
            .onDisappear { timerManager.stop() }
            
        }.onChange(of: shouldResetTimer, initial: false) { _, newValue in
            if(newValue)
            {
                timerManager.start()
            }
        }
    }
}

#Preview() {
    TimerView(durationInMinutes: 1)
}

