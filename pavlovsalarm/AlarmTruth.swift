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
        
        //remove following code and use the add notification
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
        printPendingNotifications()
    }
    
    mutating func deleteAlarm(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = alarms[index]
            removeNotification(withIdentifier: alarm.id.uuidString)
        }
        alarms.remove(atOffsets: offsets)
    }
    
    mutating func unscheduleAlarm(withId id: UUID) {
        if let alarmIndex = alarms.firstIndex(where: { $0.id == id }) {//I dont really understand this line
            let alarm = alarms[alarmIndex]
            removeNotification(withIdentifier: alarm.id.uuidString)
            alarms[alarmIndex].isEnabled = false
        }
    }
    
    mutating func scheduleAlarm(withId id: UUID) {
        if let alarmIndex = alarms.firstIndex(where: { $0.id == id }) {//I dont really understand this line
            alarms[alarmIndex].updateRandomTime()
            addNotification(alarm: alarms[alarmIndex])
            alarms[alarmIndex].isEnabled = true
        }
    }
    
    private func addNotification(alarm: Alarm) {
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
        print("reschuled alarm new time is: \(alarm.time)")
    }
    
    private func removeNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        printPendingNotifications()
    }
    
    //this is not working
    private func printPendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getPendingNotificationRequests { requests in
            print("There are \(requests.count) pending notifications.")
            
            for request in requests {
                print("Notification ID: \(request.identifier)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let triggerDate = trigger.nextTriggerDate() {
                    print("Scheduled Time: \(triggerDate)")
                }
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
            }
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
        
        mutating func updateRandomTime() {
            self.time = randomDateBetween(start: self.start_time, end: self.end_time)
        }
    }
}

