//
//  Utils.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import SwiftUI
import UserNotifications

class Utils {
    static var shared = Utils()
    
    func sendMail(body: String, subject: String) {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        
        service?.recipients = ["ECi_Mobile@jalasoft.com"]
        service?.subject = subject
        service?.perform(withItems: [body])
    }
}

class NotificationsManager {
    static var shared = NotificationsManager()
    
    func sendNotification() {
        
    }
}
