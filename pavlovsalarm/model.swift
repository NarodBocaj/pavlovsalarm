//
//  model.swift
//  pavlovsalarm
//
//  Created by Jacob Doran on 5/27/24.
//

import Foundation

class AlarmModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var time: Date
    
    init(time: Date) {
        self.time = time
    }
}
