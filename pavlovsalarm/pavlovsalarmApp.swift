//
//  pavlovsalarmApp.swift
//  pavlovsalarm
//
//  
//

import SwiftUI

@main
struct AlarmApp: App {
    init() {
        AlarmManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            AlarmView()
        }
    }
}
