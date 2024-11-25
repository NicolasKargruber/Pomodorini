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
    
    init(duration: Int = 25 * 60, pomodoro: Pomodoro? = nil) {
        self.viewModel = ViewModel2(seconds: duration)
        self.pomodoro = pomodoro
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(viewModel.formatedCounter)
                .font(.system(size: 80, weight: .bold))
                .padding()
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 25) {
                HStack(spacing: 25) {
                    Circle().foregroundColor(viewModel.pomodorColor)
                        .frame(width: viewModel.pomodoroSize)
                    Circle().foregroundColor(Color.green)
                        .frame(width: 25)
                    Circle().foregroundColor(Color.green)
                        .frame(width: 25, height: 25)
                }
                HStack(spacing: 25) {
                    Circle().foregroundColor(Color.green)
                        .frame(width: 25, height: 25)
                    Circle().foregroundColor(Color.green)
                        .frame(width: 25, height: 25)
                    Circle().foregroundColor(Color.green)
                        .frame(width: 25, height: 25)
                }
                Circle().foregroundColor(Color.green)
                    .frame(width: 25, height: 25)
            }.padding([.bottom])
            
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
    }
}

#Preview {
    PlantFarmView(duration: 15)
}

