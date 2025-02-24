//
//  LiveActivityManager.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 24.02.25.
//

import Foundation
import ActivityKit
import SwiftUICore


class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<PomodorinoTimerAttributes>?

    private init() {}
    
    // Start Live Activity
    func startActivity(formattedTime: String, pomdorinoColor: Color)  {
            print("LiveActivityManager | Start Live Activity")
            do{
                let hexColor = pomdorinoColor.toHex() ?? "000000"
                
                let staticAttributes = PomodorinoTimerAttributes(taskLabel: "Lernen")
                let initialState:PomodorinoTimerAttributes.ContentState = PomodorinoTimerAttributes.ContentState(formattedTime: formattedTime, hexColor: hexColor)

                activity = try Activity<PomodorinoTimerAttributes>.request(
                    attributes: staticAttributes,
                    content: .init(state: initialState, staleDate: nil)
                )
               
                print("LiveActivityManager | Started Live Activity")
                
            } catch{
                print("LiveActivityManager | Couldn't start activity: "+error.localizedDescription)
            }
        }
    
    // Update Live Activity
    func updateActivity(formattedTime: String, pomdorinoColor: Color) {
        guard let activity = activity else { return }
        
        guard let hexColor = pomdorinoColor.toHex()
        else { return print("LiveActivityManager | No valid color from hex string") }
        
        let updatedState = PomodorinoTimerAttributes.ContentState(formattedTime: formattedTime, hexColor: hexColor)
        
        Task {
            await activity.update(ActivityContent<PomodorinoTimerAttributes.ContentState>(state: updatedState, staleDate: nil))
        }
    }
    
    // End Live Activity
    func endActivity(formattedTime: String, pomdorinoColor: Color) {
        guard let activity = activity else { return }
        
        print("LiveActivityManager | End Live Activity")
        
        guard let hexColor = pomdorinoColor.toHex()
        else { return print("LiveActivityManager | No valid color from hex string") }
        
        let finalState = PomodorinoTimerAttributes.ContentState(formattedTime: formattedTime, hexColor: hexColor)
        
        Task {
            await activity.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
            print("LiveActivityManager | Ended Live Activity")
        }
    }
}
