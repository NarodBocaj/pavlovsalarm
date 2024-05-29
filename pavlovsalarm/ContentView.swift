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
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Set Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    
                    Button("Save Alarm") {
                        let newAlarm = AlarmModel(time: selectedTime)
                        AlarmManager.shared.scheduleNotification(for: newAlarm)
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
