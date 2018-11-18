//
//  SuccessViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit
import UserNotifications

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self
        scheduleNotifications()
    }
    
    func scheduleNotifications() {
        
        let content = UNMutableNotificationContent()
        let requestIdentifier = "rajanNotification"
        
        content.badge = 1
        content.title = "Crédito disponível"
        content.body = "Você já pode resgatar seu crédito no banco XXX apresentando seu RG."
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            print("Notification Register Success")
        }
    }
}

extension SuccessViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
}
