//
//  AmerApp.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI

@main
struct AmerApp: App {
//    @StateObject private var ButtonsVM = ButtonsViewModel()
//    @StateObject private var userVM = UserViewModel()
//    @StateObject private var memberVM = MembersViewModel()
//    @StateObject private var noteVM = NotificationViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                LoginSignupView()
                    .environmentObject(ButtonsViewModel())
                    .environmentObject(UserViewModel())
                    .environmentObject(MembersViewModel())
            } else {
                Onboarding_1()
                    .environmentObject(ButtonsViewModel())
                    .environmentObject(UserViewModel())
                    .environmentObject(MembersViewModel())
            }
        }
    }
}

