//
//  AlarmController.swift
//  AlarmiOS27
//
//  Created by Austin West on 6/17/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController {
    
    static let sharedInstance = AlarmController()
    
    init() {
        print(fileURL())
    }
    
    var alarms: [Alarm] = []
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarm.enabled = enabled
        AlarmController.sharedInstance.alarms.append(alarm)
        
        saveToPersistentStorage()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        
        guard let index = AlarmController.sharedInstance.alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: index)
        
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
    }
    
    private func fileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "AlarmiOS27Entries.json"
        let documentsDirectoryURL = path[0].appendingPathComponent(fileName)
        print(documentsDirectoryURL)
        
        return documentsDirectoryURL
    }
    
    //    Persistence
    //    method signatures (CALL THESE)
    func saveToPersistentStorage() {
        //        Create an instance of JSONEncoder
        let jsonEncoder = JSONEncoder()
        //        Attempt to convert our playlists to JSON
        do {
            let jsonEntry = try jsonEncoder.encode(alarms)
            //            with the new json playlist, save it to the file we created
            try jsonEntry.write(to: fileURL())
        } catch let encodingError {
            //            Handle the error if there is one
            print("There was an error saving the data as JSON!! \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPersisentStorage() -> [Alarm]{
        let decoder = JSONDecoder()
        
        do{
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("Failed to Load from Persistent Store \(error) \(error.localizedDescription)")
        }
        return []
    }
}

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

extension AlarmScheduler{
    
    func scheduleUserNotification(for alarm: Alarm){
        
        let content = UNMutableNotificationContent()
        content.title = "It's time to wake up, like now!"
        content.body = "Your alarm \(alarm.name) is yelling at you!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error scheduling local user notifications \(error.localizedDescription)  :  \(error)")
            }
        }
        
    }
    
    func cancelUserNotification(for alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
