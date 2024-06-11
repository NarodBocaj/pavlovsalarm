//
//  manager.swift
//  pavlovsalarm
//
//  
//

import UserNotifications

class AlarmButler: ObservableObject {
    @Published private var truth = AlarmTruth()
    
    var alarms: Array<AlarmTruth.Alarm> {
        return truth.alarms
    }
    
    func addNewAlarm(start_time: Date, end_time: Date) {
        truth.addAlarm(start: start_time, end: end_time)
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        truth.deleteAlarm(at: offsets)
    }
    
    func unscheduleAlarm(for id: UUID) {
        truth.unscheduleAlarm(withId: id)
    }
    
    func scheduleAlarm(for id: UUID) {
        truth.scheduleAlarm(withId: id)
    }
    
    static func requestAuthorization() {
            let options: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
                if success {
                    print("Authorization granted.")
                } else if let error = error {
                    print("Authorization denied with error: \(error.localizedDescription)")
                }
            }
        }
    
    
}
