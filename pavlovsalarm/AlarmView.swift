//
//  ContentView.swift
//  pavlovsalarm
//
//  
//

import SwiftUI

struct AlarmListView: View {
    @ObservedObject var Butler: AlarmButler
    
    var body: some View {
        List {
            ForEach(Butler.alarms) { alarm in
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
    @ObservedObject var Butler: AlarmButler
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack{
                        DatePicker("Set Time", selection: $startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                        DatePicker("Set Time", selection: $endTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Button("Save Alarm") {
//                        let newAlarm = AlarmModel(start_time: startTime, end_time: endTime)
//                        AlarmButler.shared.scheduleNotification(for: newAlarm)
                        Butler.addNewAlarm(start_time: startTime, end_time: endTime)
                    }
                }
                .navigationTitle("Alarm")
                
                AlarmListView(Butler: Butler)
            }
        }
    }
}


#Preview {
    AlarmView(Butler: AlarmButler())
}
