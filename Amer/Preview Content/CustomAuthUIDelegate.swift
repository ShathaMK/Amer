//
//  CustomAuthUIDelegate.swift
//  Amer
//
//  Created by Noori on 30/12/2024.
//


// MARK: - trying the work of a guy called Sheehan Munim

import SwiftUI
import Firebase
import UIKit
import FirebaseAuth
import CloudKit


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        //  Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                application.registerForRemoteNotifications()
            }
        }
        // Check notification permission status
               UNUserNotificationCenter.current().getNotificationSettings { settings in
                   if settings.authorizationStatus == .authorized {
                       print("Notification permissions granted.")
                   } else {
                       print("Notification permissions not granted.")
                   }
               }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox) //.unknown

        
        // Save device token to CloudKit for the assistant
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device token received: \(tokenString)")
        // Assuming you have a method to save the device token in a `User` record
        saveDeviceTokenToCloudKit(deviceToken: tokenString, phoneNumber: "549646311")

    }
    
    func application(_ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
      // This notification is not auth related; it should be handled separately.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        } else {
            return false
        }
              
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for remote notifications: \(error)")
     }
    
    // MARK: - Foreground Notification Handling
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification received: \(notification.request.content.title)")
        
        // Use the new presentation options (banner/list) instead of `.alert`
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound]) // Show the notification as a banner and play a sound
        } else {
            completionHandler([.alert, .sound]) // Fallback for earlier versions of iOS
        }
    }
    // MARK: - Background/Tapped Notification Handling
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // This method is called when the user interacts with a notification (e.g., tapping it)
        let userInfo = response.notification.request.content.userInfo
        print("Tapped notification: \(userInfo)")
        // You can handle navigation or data updates here
        completionHandler()
    }
    
    func saveDeviceTokenToCloudKit(deviceToken: String, phoneNumber: String) {
        let database = CKContainer.default().publicCloudDatabase
        
        // Query the user by phone number
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let records = records, let userRecord = records.first {
                userRecord["deviceToken"] = deviceToken
                
                // Save the updated record
                database.save(userRecord) { _, saveError in
                    if let saveError = saveError {
                        print("Error saving device token: \(saveError)")
                    } else {
                        print("Device token successfully saved!")
                    }
                }
            } else if let error = error {
                print("Error fetching user record: \(error)")
            }
        }
    }





    
    
    
}
