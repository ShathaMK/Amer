//
//  ContentView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 14/06/1446 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Onboarding_1()
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
