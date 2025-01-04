//
//  LoginSignupView.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import FirebaseAuth

struct LoginSignupView: View {
//    @StateObject var userVM = UserViewModel()
    @EnvironmentObject var userVM: UserViewModel

    @State var selectedTab = 0 // State to track active tab

    var body: some View {
        if userVM.isAuthenticated {
            RemoteView()
                .environmentObject(ButtonsViewModel())
                .environmentObject(UserViewModel())
        } else {
            NavigationView {
                VStack {
                    // Custom Tab Switcher
                    ZStack {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Border
                            )

                        HStack {
                            // Sign Up Tab
                            Button(action: {
                                selectedTab = 0
                                userVM.triggerHapticFeedback() // Haptic feedback
                            }) {
                                Text("Sign Up")
                                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(selectedTab == 0 ? Color("ColorGreen") : Color.clear) // Selected background
                                    .foregroundColor(selectedTab == 0 ? .white : Color("FontColor")) // Text color
                                    .cornerRadius(8)
                            }

                            // Log In Tab
                            Button(action: {
                                selectedTab = 1
                                userVM.triggerHapticFeedback() // Haptic feedback
                            }) {
                                Text("Log In")
                                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(selectedTab == 1 ? Color("ColorGreen") : Color.clear) // Selected background
                                    .foregroundColor(selectedTab == 1 ? .white : Color("FontColor")) // Text color
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 32)

                    // Dynamic Content
                    if selectedTab == 0 {
                        SignUp() // Sign Up View
                            .environmentObject(ButtonsViewModel())
                            .environmentObject(UserViewModel())
                    } else {
                        LogIn() // Log In View
                            .environmentObject(ButtonsViewModel())
                            .environmentObject(UserViewModel())
                    }

                    Spacer()
                }
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    LoginSignupView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
}
