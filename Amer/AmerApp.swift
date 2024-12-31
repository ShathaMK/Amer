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
    var body: some Scene {
        WindowGroup {
            //Onboarding_1()
        AddNewButtonView().environmentObject(ButtonsViewModel()) // Inject EnvironmentObject here


        }
    }
}
