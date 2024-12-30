//
//  AmerApp.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct AmerApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewModel = ButtonsViewModel()
    
    var body: some Scene {
        WindowGroup {
            Onboarding_1()

        }
    }
}



// MARK: - i could use smth else but lets keep on trac with the traditional

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        FirebaseApp.configure()
//        print("FireBase is here to Serve!!!")
//        return true
//    }
//}


// MARK: - here i am improving it to able to send and recive from the FireBase
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        print("FireBase is here to Serve!!!")
        
        return true
    }
}
