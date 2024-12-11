//
//  TimerView.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

struct TimerView: View {
    @State private var shouldResetTimer = false

    @State var pomodorinoCount = 0
    @State var timerManager: TimerManager
    
    init(durationInMinutes: Int = 25) {
        try! self.timerManager = TimerManager(
            totalMinutes: durationInMinutes, allowsOvertime: false)
    }
    
    var isGrowing: Bool {
        self.timerManager.isRunning
    }
    
    var isRipe: Bool {
        self.timerManager.isCompleted
    }
    
    var pomdoroRipeness: Double {
        self.timerManager.progress
    }
    
    var pomodoroColor: Color {
        do {
            return try PomodorinoGradient.color(forRipeness: pomdoroRipeness)
            } catch {
                print("Error info: \(error)")
            }
        return Color.black
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {
                
                // MARK: - Background
                LinearGradient(gradient: Gradient(colors: [pomodoroColor, pomodoroColor.mix(with: Color.black, by: 0.2), ]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea().overlay {
                    Image("Pomodorini_Hat").offset(x: 90, y: -320)
                }
                
                // MARK: - Content
                VStack {
                    Button("\(pomodorinoCount) 🍅", action: {})
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .buttonStyle(.bordered).tint(.white).frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(){
                        
                        VStack(alignment: .trailing) {
                            
                            Text("Goal: 25:00")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white).padding(.horizontal, 72)
                            
                            Text(timerManager.formattedTime)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white).frame(maxWidth: .infinity)
                            
                        }.frame(maxWidth: .infinity)
                        
                        // MARK: - Timer Button
                        TimerButton(
                            pomodorinoCount: $pomodorinoCount,
                            shouldResetTimer: $shouldResetTimer,
                            state: timerButtonState,
                            onStart: { timerManager.start() },
                            onNavigate: {}
                        )
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
            }
            .onDisappear { timerManager.stop() }
            
        }.onChange(of: shouldResetTimer, initial: false) { _, newValue in
            if(newValue)
            { timerManager.start() }
        }
    }
    
    private var timerButtonState: TimerButton.TimerState {
            if isRipe {
                return .finished
            } else if isGrowing {
                return .running
            } else {
                return .notStarted
            }
        }
}

#Preview() {
    TimerView(durationInMinutes: 1)
}


