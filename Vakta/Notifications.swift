//
//  Notifications.swift
//  Vakta
//
//  Created by Johannes Sörensen on 2021-03-28.
//
import UserNotifications

class Notifications {
    
    static var global = Notifications()
    private init() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Ok")
            }
            else {
                print("No")
            }
        }
    }
    
    func send(message: String){        
        let content = UNMutableNotificationContent()
        content.title = message
        content.categoryIdentifier = "vakta"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
   
    
}
