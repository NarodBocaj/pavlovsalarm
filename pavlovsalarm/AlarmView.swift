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
                Text(
                    //would like this to be on one line each but not sure how
                    "Start Time: \(alarm.start_time, formatter: timeFormatter) End Time: \(alarm.end_time, formatter: timeFormatter) Rand Time: \(alarm.time, formatter: timeFormatter)"
                )
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
