//
//  AmerApp.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI
import Firebase

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



// i could use smth else but lets keep on trac with the traditional

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        print("FireBase is here to Serve!!!")
        return true
    }
}

