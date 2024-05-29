//
//  manager.swift
//  pavlovsalarm
//
//  Created by Jacob Doran on 5/27/24.
//

import UserNotifications

class AlarmManager: ObservableObject {
    static let shared = AlarmManager()
    @Published var alarms: [AlarmModel] = []
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Authorization granted.")
            } else if let error = error {
                print("Authorization denied with error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for alarm: AlarmModel) {
        alarms.append(alarm)
        print("weewoo")
        print(alarms)
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Your alarm is going off!"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        
        
    }
    
    func cancelNotification(for alarm: AlarmModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
}
