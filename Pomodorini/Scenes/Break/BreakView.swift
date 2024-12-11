//
//  BreakView.swift
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
    
    var pomdorinoRipeness: Double {
        self.timerManager.progress
    }
    
    var pomodorinoImage: String {
        do {
            return try PomodorinoGrowth.imageName(forRipeness: pomdorinoRipeness)
        } catch {
            print("Error info: \(error)")
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            
            // Background Color
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), Color(#colorLiteral(red: 0.03041391261, green: 0.3515392542, blue: 0.02641633712, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea().overlay {
                // Background Scene
                Ellipse()
                    .fill(Color.white).opacity(0.1)
                    .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                    .offset(y: +430)
                
                /*Ellipse()
                    .fill(Color.black).opacity(0.3)
                    .frame(width: UIScreen.main.bounds.width * 1, height: 150) // Oversized width
                    .offset(y: 400)*/
                
                Circle()
                    .fill(.white).opacity(0.3)
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
                        
                        Image(pomodorinoImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .animation(.snappy(duration: 1.8), value: pomodorinoImage)
                        
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

