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
        AlarmButler.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            AlarmView(Butler: AlarmButler())
        }
    }
}
