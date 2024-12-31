//
//  CustomAuthUIDelegate.swift
//  Amer
//
//  Created by Noori on 30/12/2024.
//




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
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//            guard granted else { return }
//            DispatchQueue.main.async {
//                application.registerForRemoteNotifications()
//            }
//        }
//        
//        print("FireBase is here to Serve!!!")
//        
//        return true
//    }
//}

//import SwiftUI
//import Foundation
//import FirebaseCore
//import FirebaseMessaging
//import UserNotifications
//import FirebaseAuth
//import UIKit


// MARK: - here i am improving it to able to send and recive from the FireBase Auth

//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//            guard granted else { return }
//            DispatchQueue.main.async {
//                application.registerForRemoteNotifications()
//            }
//        }
//        
//        handleSignInWithEmailLink() // Handle sign-in links if applicable
//        print("Firebase is here to Serve!!!")
//        return true
//    }
//    
//    private func handleSignInWithEmailLink() {
//        if let link = UserDefaults.standard.string(forKey: "FirebaseEmailLink") {
//            if Auth.auth().isSignIn(withEmailLink: link) {
//                let email = "user@example.com" // Retrieve the email used for the link
//                Auth.auth().signIn(withEmail: email, link: link) { result, error in
//                    if let error = error {
//                        print("Error signing in: \(error.localizedDescription)")
//                    } else {
//                        print("User signed in successfully!")
//                    }
//                }
//            }
//        }
//    }
//    
//    
//}




// MARK: -


//import FirebaseCore
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//import FirebaseAuth
//import UIKit
//
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//            FirebaseApp.configure()
//
//            // Set Messaging delegate
//            Messaging.messaging().delegate = self
//
//            // Set UNUserNotificationCenter delegate
//            UNUserNotificationCenter.current().delegate = self
//        
//            UserDefaults.standard.setValue(true, forKey: "FIRAuthDebugEnabled")
//
//            // Request notification permissions
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//                guard granted else { return }
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                    application.registerForRemoteNotifications()
//                }
//            }
//
//            return true
//        }
//
//    // MARK: - Handle APNs Token Registration
////    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
////        Messaging.messaging().apnsToken = deviceToken
////        print("APNs device token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
////    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//            Messaging.messaging().apnsToken = deviceToken
//            print("APNs token set for Messaging.")
//        }
//    
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register for remote notifications: \(error.localizedDescription)")
//    }
//
//    // MARK: - Handle Notifications
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Received remote notification: \(userInfo)")
//        completionHandler(.newData)
//    }
//    
//
//        // MARK: - Handle Incoming Notifications
////        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
////            print("Notification received: \(response.notification.request.content.userInfo)")
////            completionHandler()
////        }
////
////        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
////            completionHandler([.banner, .sound, .badge])
////        }
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//           completionHandler([.banner, .sound, .badge])
//       }
//
//       // MARK: - FCM Token Handling
//       func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//           print("Firebase FCM registration token: \(fcmToken ?? "")")
//       }
//    
//    
//}
//
//
//
//
//class AuthManager {
//    static let shared = AuthManager()
//
//    private init() {}
//
//    func verifyPhoneNumber(_ phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            completion(verificationID, nil)
//        }
//    }
//
//    func signInWithVerificationCode(verificationID: String, verificationCode: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
//        Auth.auth().signIn(with: credential) { authResult, error in
//            completion(authResult, error)
//        }
//    }
//}




// MARK: - trying the work of a guy called Sheehan Munim

import SwiftUI
import Firebase
import UIKit
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox) //.unknown
        print("Device token received: \(deviceToken.map { String(format: "%02x", $0) }.joined())")
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
}
