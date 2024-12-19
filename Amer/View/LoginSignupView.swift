//
//  LoginSignupView.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct LoginSignupView: View {
    @State private var selectedTab = 0 // State to track active tab

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Segmented Picker
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("تسجيل دخول").tag(0) // Login
                    Text("حساب جديد").tag(1) // Signup
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Content changes dynamically
                if selectedTab == 0 {
                    LogIn() // Show LoginView
                } else {
                    SignUp() // Show SignupView
                }

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(UIColor.systemGray6)) // Optional background color
        }
    }
}

#Preview {
    LoginSignupView()
}


#Preview {
    LoginSignupView()
}
