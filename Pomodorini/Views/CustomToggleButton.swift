//
//  CustomToggleButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 08.03.25.
//

import SwiftUI

struct CustomToggleButton: View {
    @Binding var isOn: Bool
    var onToggle: () -> Void
    
    // Animation
    @State private var buttonScale = 1.0
    
    var body: some View {
        VStack (spacing: 4) {
            Text("Pick up where you left off?")
                .font(.title2)
                .padding(.horizontal, 18).padding(.vertical, 12)
            
            // ToggleButtons
            HStack(spacing: 24){
                Button("YES", action: {
                    isOn = true
                    onToggle()
                })
                .conditionalToggleStyle(isOn: isOn)
                .font(.title).tint(.accentColor)
                .scaleEffect(isOn ? 1.2 : 1.0)
                .animation(.bouncy, value: isOn)
                
                Button("NO", action: {
                    isOn = false
                    onToggle()
                })
                .conditionalToggleStyle(isOn: isOn, onStyle: .bordered, offStyle: .borderedProminent)
                .font(.title).tint(.blue)
                .scaleEffect(isOn ? 1.0 : 1.2)
                .animation(.bouncy(duration: 0.5), value: isOn)
            }
        }
    }
}

extension Button {
    enum CustomToggleStyle {
        case borderedProminent
        case bordered
    }
    
    @ViewBuilder
    private func toggleStyleToButtonStyle(_ style: CustomToggleStyle) -> some View {
        switch style {
        case .borderedProminent:
            self.buttonStyle(.borderedProminent)
        case .bordered:
            self.buttonStyle(.bordered)
        }
    }
        
    @ViewBuilder
    func conditionalToggleStyle(isOn: Bool,
        onStyle: CustomToggleStyle = .borderedProminent,
        offStyle: CustomToggleStyle = .bordered) -> some View {
        
        if(isOn){ self.toggleStyleToButtonStyle(onStyle) }
        else { self.toggleStyleToButtonStyle(offStyle) }
    }
}

#Preview {
    @Previewable @State var isToggled = false
    
    CustomToggleButton(isOn: $isToggled) {}
}
