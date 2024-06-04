//
//  model.swift
//  pavlovsalarm
//
//  
//

import Foundation
import UserNotifications

struct AlarmTruth {
    private(set) var alarms: Array<Alarm> = []
    
    mutating func addAlarm(start: Date, end: Date) {
        let new_alarm = Alarm(start_time: start, end_time: end)
        alarms.append(new_alarm)
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Your alarm is going off!"
        content.sound = UNNotificationSound.default
                
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: new_alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
        let request = UNNotificationRequest(identifier: new_alarm.id.uuidString, content: content, trigger: trigger)
                
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        print("weewoo")
        print(alarms)
    }
    
    private static func randomDateBetween(start: Date, end: Date) -> Date {
        // changing everything to structs broike this for some reason, switching it around fixed it, not sure why
        let interval = max(start.timeIntervalSince(end), 0)  // Ensure the interval is non-negative
        if interval == 0 {
            return start  // Return start if start and end are the same or end is before start
        }
        let clampedInterval = min(interval, Double(UInt32.max))  // Clamp to UInt32.max
        let randomInterval = TimeInterval(arc4random_uniform(UInt32(clampedInterval)))
        return start.addingTimeInterval(randomInterval)
//        let interval = end.timeIntervalSince(start)
//        let randomInterval = TimeInterval(arc4random_uniform(UInt32(interval)))
//        return start.addingTimeInterval(randomInterval)
    }
    
    struct Alarm: Identifiable {
        let id = UUID()
        var start_time: Date
        var end_time: Date
        var time: Date
        
        init(start_time: Date, end_time: Date) {
            self.start_time = start_time
            self.end_time = end_time
            self.time = randomDateBetween(start: start_time, end: end_time)
        }
    }
}
