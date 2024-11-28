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
            ZStack(alignment: .topLeading) {
                VStack {
                    Text(viewModel.formatedCounter)
                        .font(.system(size: 80, weight: .bold))
                        .padding()
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewModel.startTimer()
                        viewModel.buttonScale = 0.4
                    }) {
                        if viewModel.buttonScale == 1 && !viewModel.isRipe {Text("Start")}
                        else if viewModel.isRipe {
                            NavigationLink(destination: PlantFarmView(pomodoro: Pomodoro(ripeness: viewModel.pomdoroRipeness, size: viewModel.seconds))){
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
                    .scaleEffect(viewModel.buttonScale)
                    .animation(.easeIn, value: viewModel.buttonScale)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(viewModel.pomodoroColor)
                    .onDisappear {
                        viewModel.stopTimer()
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
}

#Preview() {
    PomodoroTimerView(duration: 5)
}

