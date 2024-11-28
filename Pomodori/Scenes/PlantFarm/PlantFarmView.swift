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
        
        viewModel.startTimer()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                VStack {
                    Spacer()
                    Image("Pomodorini-Unripe")
                        .scaleEffect(viewModel.pomodoroSize)
                        .grayscale(1)
                        .colorMultiply(viewModel.pomodoroColor)
                        .luminanceToAlpha()
                }.frame(width: 50,height: 50)
                    .padding(.vertical)
                
                Button(action: viewModel.stopTimer) {
                    Text("Collect").font(.title)
                }
                .disabled(!viewModel.isRipe)
                .buttonStyle(.bordered).tint(.white)
                
                Text(viewModel.formatedCounter)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
            }.containerRelativeFrame([.horizontal, .vertical])
                .background(Color.teal)
            
            
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
            
            Button("0 🍅", action: {})
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .buttonStyle(.bordered).tint(.white)
                .frame(alignment: .topTrailing)
                .padding(.horizontal, 48) .padding(.vertical, 8)
                // TODO: Remove offset in POM-21
                .offset(x: 140,y: -350)
        }
    }
}

#Preview {
    PlantFarmView(duration: 15, pomodoro: Pomodoro(ripeness: 1.2, size: 100))
}

