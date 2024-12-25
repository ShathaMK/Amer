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
            AddNewButtonView()
                .environmentObject(viewModel) // Pass the viewModel down the navigation stack

          

        }
    }
}
