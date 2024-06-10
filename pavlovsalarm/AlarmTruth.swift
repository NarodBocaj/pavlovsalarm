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
    
    mutating func deleteAlarm(at offsets: IndexSet) {
        //this function still needs to remove the notification I believe
        //right now it just removes the alarm from the list
        alarms.remove(atOffsets: offsets)
    }
    
    mutating func unscheduleAlarm(withId id: UUID) {
        if let alarmIndex = alarms.firstIndex(where: { $0.id == id }) {//I dont really understand this line
//            let alarm = alarms[alarmIndex]
//            removeNotification(withIdentifier: alarm.notificationID)
            alarms[alarmIndex].isEnabled = false
        }
    }
    
    mutating func scheduleAlarm(withId id: UUID) {//This rescheduling kind of effect needs to reroll the randtime
        if let alarmIndex = alarms.firstIndex(where: { $0.id == id }) {//I dont really understand this line
//            let alarm = alarms[alarmIndex]
//            createNotification(withIdentifier: alarm.notificationID)
            alarms[alarmIndex].isEnabled = true
        }
    }
    
    private static func randomDateBetween(start: Date, end: Date) -> Date {
        let interval = end.timeIntervalSince(start)
        let randomInterval = TimeInterval(arc4random_uniform(UInt32(interval)))
        return start.addingTimeInterval(randomInterval)
    }
    
    struct Alarm: Identifiable {
        let id = UUID()
        var start_time: Date
        var end_time: Date
        var time: Date
        var isEnabled: Bool = true
        
        init(start_time: Date, end_time: Date) {
            self.start_time = start_time
            self.end_time = end_time
            self.time = randomDateBetween(start: start_time, end: end_time)
        }
    }
}
