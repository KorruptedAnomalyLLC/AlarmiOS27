//
//  AlarmController.swift
//  AlarmiOS27
//
//  Created by Austin West on 6/17/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import Foundation

class AlarmController {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        
        let alarm = Alarm(fireDate: fireDate, name: name)
            alarm.enabled = enabled
            AlarmController.sharedInstance.alarms.append(alarm)
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        
    }
    
    
    
    
    
}