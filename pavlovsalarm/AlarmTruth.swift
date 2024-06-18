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
    
    private static func makeEndTimeAfterStart(start: Date, end: Date) -> Date {
        var adjustedEndTime = end
        if end < start {
            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: end)!
        }
        return adjustedEndTime
    }
    
    private static func checkStartAfterCurrent(start: Date, curr: Date) -> Bool {
        return (curr < start)
    }
    
    struct Alarm: Identifiable {
        let id = UUID()
        var start_time: Date
        var end_time: Date      //end time is now slighly obsolete with the use of adj_end_time
        var time: Date
        var isEnabled: Bool = true
        var adj_end_time: Date
        
        init(start_time: Date, end_time: Date) {
            self.start_time = start_time            //need some version of start after current, we want the alarm to go off tomorrow if the start time has already passed today
            self.end_time = end_time
            self.adj_end_time = makeEndTimeAfterStart(start: start_time, end: end_time)
            self.time = randomDateBetween(start: start_time, end: adj_end_time)
        }
        
        mutating func updateRandomTime() {
            adjustToCurrentDay(start_time: self.start_time, end_time: self.end_time)
            self.time = randomDateBetween(start: self.start_time, end: self.adj_end_time)
        }
        
        mutating func adjustToCurrentDay(start_time: Date, end_time: Date) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            let startHour = calendar.component(.hour, from: start_time)
            let startMinute = calendar.component(.minute, from: start_time)
            let endHour = calendar.component(.hour, from: end_time)
            let endMinute = calendar.component(.minute, from: end_time)
            
            var adjustedStartTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: today)!
            var adjustedEndTime = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: today)!
            
            adjustedEndTime = makeEndTimeAfterStart(start: adjustedStartTime, end: adjustedEndTime)
            
            if checkStartAfterCurrent(start: adjustedStartTime, curr: Date()) {//if the start time is before the current time, the alarm will occur tomorrow
                adjustedStartTime = Calendar.current.date(byAdding: .day, value: 1, to: adjustedStartTime)!
                adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: adjustedEndTime)!
            }
            
            self.start_time = adjustedStartTime
            self.end_time = adjustedEndTime
            self.adj_end_time = adjustedEndTime
        }
    }
}

