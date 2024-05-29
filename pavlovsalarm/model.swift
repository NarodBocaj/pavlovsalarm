//
//  model.swift
//  pavlovsalarm
//
//  
//

import Foundation

class AlarmModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var start_time: Date
    @Published var end_time: Date
    @Published var time: Date
    
    init(start_time: Date, end_time: Date) {
        self.start_time = start_time
        self.end_time = end_time
        self.time = AlarmModel.randomDateBetween(start: start_time, end: end_time)
    }
    
    static func randomDateBetween(start: Date, end: Date) -> Date {
        let interval = end.timeIntervalSince(start)
        let randomInterval = TimeInterval(arc4random_uniform(UInt32(interval)))
        return start.addingTimeInterval(randomInterval)
    }
}
