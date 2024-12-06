//
//  PlantFarmView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore
import SwiftUI

struct BreakView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var pomodorinoCount: Int
    @Binding var shouldResetTimer: Bool
    
    let finalRipeness: Double = 1.0 // 0.0 .. 1.0
    
    @State var timerManager: TimerManager
    
    init(durationInMinutes: Int = 5, pomodorinoCount: Binding<Int>, shouldResetTimer: Binding<Bool>) {
        _pomodorinoCount = pomodorinoCount
        _shouldResetTimer = shouldResetTimer
        try! self.timerManager = TimerManager(
            totalMinutes: durationInMinutes, allowsOvertime: false)
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
    
    var pomodoroSize: Double {
        PomodoroGrowth(at: pomdoroRipeness).getSize()
    }
    
    var body: some View {
        ZStack {
            
            // Background Color
            Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)).ignoresSafeArea().overlay {
                // Background Scene
                Ellipse()
                    .fill(Color.brown).colorMultiply(.green).opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                    .offset(y: +400)
                
                Ellipse()
                    .fill(Color.brown).colorMultiply(.brown).opacity(0.7)
                    .frame(width: UIScreen.main.bounds.width * 1, height: 150) // Oversized width
                    .offset(y: 400)
                
                Circle()
                    .fill(Color.yellow).colorMultiply(.yellow).opacity(0.6)
                    .frame(width: 400, height: 400)
                    .offset(x: -200,y: -460)
            }
            
            VStack(alignment: .trailing) {
                Button("\(pomodorinoCount) 🍅", action: {})
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .buttonStyle(.bordered).tint(.white)
                
                VStack(spacing: 30) {
                    
                    VStack {
                        Spacer()
                        Image("Pomodorini-Unripe")
                            .scaleEffect(pomodoroSize)
                            .grayscale(1)
                            .colorMultiply(pomodoroColor)
                            .luminanceToAlpha()
                    }.frame(width: 50,height: 50)
                        .padding(.vertical)
                    
                    Button(action: {
                        timerManager.stop()
                        pomodorinoCount += 1
                        shouldResetTimer = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Collect").font(.title)
                    }
                    .disabled(!isRipe)
                    .buttonStyle(.bordered).tint(.white)
                    
                    Text(timerManager.formattedTime)
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }.frame(maxWidth: .infinity, alignment: .trailing)
                .padding()

        }.onAppear{timerManager.start()}
    }
}

#Preview {
    @Previewable @State var pomodorini = 1
    @Previewable @State var shouldResetTimer = false
    BreakView(durationInMinutes: 1, pomodorinoCount: $pomodorini, shouldResetTimer: $shouldResetTimer)
}

