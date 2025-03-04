//
//  TalliesCalendar.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.03.25.
//


import SwiftUI

struct TalliesCalendar: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    
    // Example tally data (you'd typically load this from a data source)
    let tallyDays: Set<Int> = [8, 12, 13, 20, 21, 25]
    
    // Calendar
    var calendar = Calendar.current
    let years = [2000, 2024]
    let months = Calendar.current.monthSymbols
    
    // Weekdays in Order: M T W T F S S
    var weekdays: [String] {
        var weekdays = calendar.veryShortWeekdaySymbols
        let sunday = weekdays[0]
        weekdays.remove(at: 0); weekdays.append(sunday)
        return weekdays
    }
    
    @State private var date = Date.now
    
    @State private var selectedMonth = 0//12 //Date.now.monthInt
    @State private var selectedYear = 0//2024 // Date.now.yearInt
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("History")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Group {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(months.indices, id: \.self) { index in
                            Text(months[index]).tag(index + 1)
                        }
                    }
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id:\.self) { year in
                            Text(String(year))
                        }
                    }
                }
                .buttonStyle(.bordered)
            }
            
            // Calendar Grid
            VStack {
                // Weekday Headers
                HStack(spacing: 8) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day).frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(1...31, id: \.self) { day in
                        CalendarDayView(day: day, hasTally: tallyDays.contains(day))
                    }
                }
            }
            
            // ADD more later
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct CalendarDayView: View {
    let day: Int
    let hasTally: Bool
    
    var body: some View {
            Button(action: {}){
                
                Text("\(day)").fontWeight(.bold).font(.callout)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    //.foregroundColor(hasTally ? .red : .primary)
            }
            //.foregroundColor(hasTally ? .red : .accent)
            .clipShape(Circle())
            .buttonBorderShape(.circle).buttonStyle(.bordered)
        //.background(hasTally ? Color.red.opacity(0.1) : Color.clear)
            /*Circle()
                .fill(hasTally ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                .aspectRatio(1, contentMode: .fit)*/.overlay{
                    if hasTally {
                        Image(systemName: "\(8).circle.fill")
                                    .foregroundColor(.accentColor)
                                    .imageScale(.medium).clipShape(.circle)
                                    .offset(x: 18, y: 18)
                    }
                }
    }
}

// Preview for Xcode
#Preview {
    TalliesCalendar()
}
