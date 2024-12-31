//
//  AmerApp.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


@main
struct AmerApp: App {
    
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                if Auth.auth().currentUser != nil {
//                    Text("Welcome back, User!")
//                    // i need to add if statement if its an assistant or a reciver  to display diffrent users 
//                    
//                } else {
//                    Onboarding_1()
//                }
//            }
            
            Onboarding_1()
        }
    }
}




