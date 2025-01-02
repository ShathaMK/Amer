//
//  AmerApp.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI

@main
struct AmerApp: App {
    @StateObject private var viewModel = ButtonsViewModel()
    @StateObject private var userVM = UserViewModel()
    @StateObject private var memberVM = MembersViewModel()
//    @StateObject private var noteVM = NotificationViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            Onboarding_1()
                .environmentObject(viewModel) // Pass ButtonsViewModel
                .environmentObject(userVM) // Pass UserViewModel
                .environmentObject(memberVM) // Pass MembersViewModel
                // .environmentObject(noteVM) 
        }
    }
}
