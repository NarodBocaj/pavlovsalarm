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
                        Text("Start Time: \(alarm.start_time, formatter: timeFormatter)").foregroundColor(alarm.isEnabled ? Color.white : Color(white: 0.7))
                        Text("End Time: \(alarm.end_time, formatter: timeFormatter)").foregroundColor(alarm.isEnabled ? Color.white : Color(white: 0.7))
                        Text("Rand Time: \(alarm.time, formatter: timeFormatter)").foregroundColor(alarm.isEnabled ? Color.white : Color(white: 0.7))
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
        .listStyle(PlainListStyle())
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
    @State private var isAddingAlarm = false
    let soundOptions = ["Default", "Beep", "Chime", "Alarm", "Birds"]
    @State private var selectedSound = "Default"
    
    var body: some View {
        NavigationView {
            VStack {
                if isAddingAlarm {
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
                        Picker("Select Alarm Sound", selection: $selectedSound) {
                            ForEach(soundOptions, id: \.self) { sound in
                                Text(sound)
                            }
                        }
                        Button("Save Alarm") {
                            Butler.addNewAlarm(start_time: startTime, end_time: endTime, sound: selectedSound)
                            isAddingAlarm = false
                        }
                    }
                    .transition(.slide)
                    .animation(.easeInOut)
                }
                
                AlarmListView(Butler: Butler)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            EditButton().foregroundColor(.orange)
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                isAddingAlarm.toggle()
                            }) {
                                Image(systemName: "plus").foregroundColor(.orange)
                            }
                        }
                    }
            }
            .navigationTitle("Alarm")
        }
    }
}


#Preview {
    AlarmView(Butler: AlarmButler())
}
