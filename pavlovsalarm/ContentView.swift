//
//  ContentView.swift
//  pavlovsalarm
//
//  Created by Jacob Doran on 5/25/24.
//

import SwiftUI

struct AlarmListView: View {
    @ObservedObject var alarmManager = AlarmManager.shared
    
    var body: some View {
        List {
            ForEach(alarmManager.alarms) { alarm in
                Text("\(alarm.time, formatter: timeFormatter)")
            }
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct AlarmView: View {
    @StateObject var alarm = AlarmModel(time: Date())
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Set Time", selection: $alarm.time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    
                    Button("Save Alarm") {
                        AlarmManager.shared.scheduleNotification(for: alarm)
                    }
                }
                .navigationTitle("Alarm")
                
                AlarmListView()
                    .navigationTitle("Scheduled Alarms")
            }
        }
    }
}

#Preview {
    AlarmView()
}
