//
//  AppDelegate.swift
//  Octo Cards
//
//  Created by Linda Ho on 5/11/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let initialized = UserDefaults.standard.bool(forKey: "initialized")
        
        let color = UIColor(red: 11.0/255.0, green: 3.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        let font = UIFont(name: "ChalkboardSE-Bold"/*"Helvetica-bold"*/, size: 22)!
        
        let attributes: [String: AnyObject] = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attributes

        // Request permission to show notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            if (initialized != true) {
                UserDefaults.standard.set(Date(), forKey: "reminderTime")
                
                if (granted) {
                    UserDefaults.standard.set(true, forKey: "notificationsAllow")
                    self.scheduleLocalNotification()
                }
                else {
                    UserDefaults.standard.set(false, forKey: "notificationsAllow")
                }
                UserDefaults.standard.set(true, forKey: "initialized")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func scheduleLocalNotification() {
        print("********** APP DEL: scheduleLocalNotificationcalled ************")
        let center = UNUserNotificationCenter.current()
        
        let reminderDateTime = UserDefaults.standard.object(forKey: "reminderTime") as! Date
        let calendar = Calendar.current
        let reminderHour = calendar.component(.hour, from: reminderDateTime)
        let reminderMinutes = calendar.component(.minute, from: reminderDateTime)
        
        print("reminder Time = \(reminderHour):\(reminderMinutes)")
        
        // Cancel any prior notifications
        center.removeAllPendingNotificationRequests()
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Octo Reminder"
        notificationContent.subtitle = "Remember to practice your words!"
        //notificationContent.body = "Your most recent Octo word is XXXXX."
        
        // Add Trigger
        var dateComponents = DateComponents()
        //dateComponents.hour = reminderHour
        //dateComponents.minute = reminderMinutes
        dateComponents.hour = 15
        dateComponents.minute = 39
        
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "octo_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        center.add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }

    }
}

