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
                HStack {
                    VStack(alignment: .leading) {
                        Text("Start Time: \(alarm.start_time, formatter: timeFormatter)")
                        Text("End Time: \(alarm.end_time, formatter: timeFormatter)")
                        Text("Rand Time: \(alarm.time, formatter: timeFormatter)")
                    }
                    Spacer()
                    Toggle(isOn: Binding(
                        get: { alarm.isEnabled },
                        set: { newValue in
                            if !newValue {
                                Butler.unscheduleAlarm(for: alarm.id)
                            } else {
                                Butler.scheduleAlarm(for: alarm.id)
                            }
                        }
                    )) {
                        Text("") // Empty text label for the toggle
                    }
                    .labelsHidden()
                }
            }
            .onDelete(perform: Butler.deleteAlarm)
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
                    VStack{
                        DatePicker(
                            "Start Date",
                             selection: $startTime,
                             displayedComponents: [.date, .hourAndMinute]
                        )
                        DatePicker(
                            "End Date",
                             selection: $endTime,
                             displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                    
                    Button("Save Alarm") {
                        Butler.addNewAlarm(start_time: startTime, end_time: endTime)
                    }
                }
                .navigationTitle("Alarm")
                
                AlarmListView(Butler: Butler).toolbar{
                    EditButton()
                }
            }
        }
    }
}


#Preview {
    AlarmView(Butler: AlarmButler())
}
