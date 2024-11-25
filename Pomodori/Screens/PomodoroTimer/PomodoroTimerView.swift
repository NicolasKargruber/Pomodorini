//
//  Untitled.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

struct PomodoroTimerView: View {
    var duration: Int = 25 * 60 // In Seconds
    @State var viewModel: ViewModel
    
    init(duration: Int = 25 * 60) {
        self.viewModel = ViewModel(seconds: duration)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.formatedCounter)
                    .font(.system(size: 80, weight: .bold))
                    .padding()
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Button(action: viewModel.startTimer) {
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
                    // NavigationLink to HistoryView
                    NavigationLink(destination: PlantFarmView(pomodoro: Pomodoro(color: viewModel.pomodoroColor, size: viewModel.seconds))) {
                        Button(action: {}) {
                            Text("End")
                        }.disabled(true)
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
                    }.disabled(!viewModel.isCompleted)
                }
                
            }.containerRelativeFrame([.horizontal, .vertical])
                .background(viewModel.pomodoroColor)
                .onDisappear {
                    viewModel.stopTimer()
                }
        }
    
    }
}

#Preview() {
    PomodoroTimerView(duration: 5)
}

