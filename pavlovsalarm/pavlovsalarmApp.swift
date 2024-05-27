//
//  pavlovsalarmApp.swift
//  pavlovsalarm
//
//  Created by Jacob Doran on 5/25/24.
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
