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
    
    let totalDuration: Int // 5 * 60 .. In Seconds
    let finalRipeness: Double = 1.0 // 0.0 .. 1.0
    
    @State private var elapsedTime = 0  // Track time in seconds
    @State private var isTimerRunning = false
    
    
    // let pomodoro: Pomodoro?
    //@State var viewModel: ViewModel2
    
    init(duration: Int = 5 * 60, /*pomodoro: Pomodoro? = nil,*/ pomodorinoCount: Binding<Int>, shouldResetTimer: Binding<Bool>) {
        self.totalDuration = duration
        _pomodorinoCount = pomodorinoCount
        _shouldResetTimer = shouldResetTimer
        //self.viewModel = ViewModel2(seconds: duration, pomodoro: pomodoro)
        //self.pomodoro = pomodoro
        
        //viewModel.startTimer()
    }
    
    var isRipe: Bool {
        return elapsedTime >= totalDuration
    }
    
    var pomdoroRipeness: Double {
        (Double(elapsedTime) / Double(totalDuration)) * (finalRipeness ?? 1.0)
    }
    
    var pomodoroSize: Double {
        PomodoroGrowth(at: pomdoroRipeness).getSize()
    }
    
    var pomodoroColor: Color {
        try! PomodorinoGradient.color(for: pomdoroRipeness)
    }
    
    var formattedTime: String {
        let display = totalDuration - elapsedTime
        return String(format: "%02d:%02d", display / 60, display % 60)
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
                        isTimerRunning = false
                        pomodorinoCount += 1
                        shouldResetTimer = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Collect").font(.title)
                    }
                    .disabled(!isRipe)
                    .buttonStyle(.bordered).tint(.white)
                    
                    Text(formattedTime)
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }.frame(maxWidth: .infinity, alignment: .trailing)
                .padding()

        }.onAppear{startTimer()}
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

#Preview {
    @Previewable @State var pomodorini = 1
    @Previewable @State var shouldResetTimer = false
    BreakView(duration: 10, /*pomodoro: Pomodoro(ripeness: 1.2, size: 100),*/ pomodorinoCount: $pomodorini, shouldResetTimer: $shouldResetTimer)
}

