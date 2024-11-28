//
//  PlantFarmView.swift
//  Pomodori
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore
import SwiftUI

struct PlantFarmView: View {
    let pomodoro: Pomodoro?
    var duration: Int = 5 * 60 // In Seconds
    @State var viewModel: ViewModel2
    
    init(duration: Int = 5 * 60, pomodoro: Pomodoro? = nil) {
        self.viewModel = ViewModel2(seconds: duration, pomodoro: pomodoro)
        self.pomodoro = pomodoro
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text(viewModel.formatedCounter)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                
                Image("Pomodorini-Unripe")
                    .scaleEffect(viewModel.pomodoroSize)
                    .frame(width: 100,height: 100)
                    .grayscale(1).colorMultiply(viewModel.pomodoroColor).colorMultiply(.white)
                    .padding([.bottom])
                
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
                }
            }.containerRelativeFrame([.horizontal, .vertical])
                .background(Color.teal)
            
            Rectangle()
                .fill(Color.green)
                .frame(height: 400)
                .offset(y: +470)
            
            Ellipse()
                .fill(Color.brown)
                .frame(width: UIScreen.main.bounds.width * 1.2, height: 150) // Oversized width
                .offset(y: 400)
                    
            Circle()
                .fill(Color.yellow)
                .frame(width: 400, height: 400)
                .offset(x: -200,y: -460)
        }
    }
}

#Preview {
    PlantFarmView(duration: 15, pomodoro: Pomodoro(ripeness: 1.2, size: 100))
}

