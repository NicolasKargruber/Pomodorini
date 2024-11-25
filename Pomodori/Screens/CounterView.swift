//
//  Untitled.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

struct CounterView: View {
    
    @State var counter: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
            VStack {
                Text(formatedCounter())
                    .font(.system(size: 80, weight: .bold, design: .default))
                    .padding()
                    .foregroundColor(.white)
                
                Button(action: startTimer) {
                    Text("Start")
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
                
            }.containerRelativeFrame([.horizontal, .vertical])
            .background(pomodorColor())
            .onDisappear {
                stopTimer()
            }
    }
    
    func pomodorColor() -> Color {
        PomodoroGradient(at: Double(counter) / 300).getColor()
    }
    
    func formatedCounter() -> String {
        String(format: "%02d:%02d", counter / 60, counter % 60)
    }
    
    func startTimer() {
        guard timer == nil else { return }
        
        // Start a timer that increments the counter every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.counter += 1
        }
    }
    
    func stopTimer() {
        // Invalidate the timer when the view disappears
        timer?.invalidate()
        timer = nil
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}

