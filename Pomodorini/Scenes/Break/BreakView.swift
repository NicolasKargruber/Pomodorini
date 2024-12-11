//
//  BreakView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore
import SwiftUI

/// A view that represents the break screen in the Pomodorino app.
///
/// The break screen allows users to view the ripening Pomodorino during a countdown
/// and collect it once the timer completes.
struct BreakView: View {
    // MARK: - Environment
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Bindings
    /// The current count of collected Pomodorini.
    @Binding var pomodorinoCount: Int
    
    /// A flag to indicate whether the timer should reset.
    @Binding var shouldResetTimer: Bool

    // MARK: - State
    /// The timer manager responsible for tracking the break timer.
    @State private var timerManager: TimerManager

    // MARK: - Initializer
    /// Initializes the `BreakView` with the specified duration and bindings.
    /// - Parameters:
    ///   - durationInMinutes: The duration of the break timer in minutes. Default is 5 minutes.
    ///   - pomodorinoCount: A binding to the current Pomodorino count.
    ///   - shouldResetTimer: A binding to the timer reset state.
    init(
        durationInMinutes: Int = 5,
        pomodorinoCount: Binding<Int>,
        shouldResetTimer: Binding<Bool>
    ) {
        _pomodorinoCount = pomodorinoCount
        _shouldResetTimer = shouldResetTimer
        try! self.timerManager = TimerManager(
            totalMinutes: durationInMinutes, allowsOvertime: false)
    }

    // MARK: - Computed Properties
    /// Indicates whether the Pomodorino is ripe (timer has completed).
    private var isRipe: Bool {
        timerManager.isCompleted
    }

    /// Represents the ripeness of the Pomodorino as a value between 0.0 and 1.0.
    private var pomodorinoRipeness: Double {
        timerManager.progress
    }

    /// Determines the appropriate Pomodorino image based on its ripeness.
    private var pomodorinoImage: String {
        do {
            return try PomodorinoGrowth.imageName(forRipeness: pomodorinoRipeness)
        } catch {
            print("Error determining image: \(error)")
            return ""
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.584, green: 0.824, blue: 0.420, alpha: 1)),
                    Color(#colorLiteral(red: 0.030, green: 0.352, blue: 0.026, alpha: 1))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .overlay {
                // Decorative Elements
                Ellipse()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                    .offset(y: 430)

                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 400, height: 400)
                    .offset(x: -200, y: -460)
            }

            VStack(alignment: .trailing) {
                // MARK: Pomodorino Count
                Button("\(pomodorinoCount) 🍅", action: {})
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                    .tint(.white)

                VStack(spacing: 30) {
                    // MARK: Pomodorino Display
                    VStack {
                        Spacer()

                        Image(pomodorinoImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .animation(.snappy(duration: 1.8), value: pomodorinoImage)
                    }
                    .frame(width: 50, height: 50)
                    .padding(.vertical)

                    // MARK: Collect Button
                    Button(action: collectPomodorino) {
                        Text("Collect")
                            .font(.title)
                    }
                    .disabled(!isRipe)
                    .buttonStyle(.bordered)
                    .tint(.white)

                    // MARK: Timer Display
                    Text(timerManager.formattedTime)
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
        .onAppear { timerManager.start() }
    }

    // MARK: - Actions
    /// Handles the collection of a ripe Pomodorino.
    private func collectPomodorino() {
        timerManager.stop()
        pomodorinoCount += 1
        shouldResetTimer = true
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var pomodorini = 1
    @Previewable @State var shouldResetTimer = false
    BreakView(
        durationInMinutes: 1,
        pomodorinoCount: $pomodorini,
        shouldResetTimer: $shouldResetTimer
    )
}
