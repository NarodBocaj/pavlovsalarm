//
//  ContentView.swift
//  pavlovsalarm
//
//  Created by Jacob Doran on 5/25/24.
//

import SwiftUI

struct AlarmView: View {
    @StateObject var alarm = AlarmModel(time: Date())
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Set Time", selection: $alarm.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                
                Button("Save Alarm") {
                    AlarmManager.shared.scheduleNotification(for: alarm)
                }
            }
            .navigationTitle("Alarm")
        }
    }
}

#Preview {
    AlarmView()
}
