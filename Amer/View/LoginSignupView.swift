//
//  LoginSignupView.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct LoginSignupView: View {
    @State private var selectedTab = 0 // State to track active tab
    @State private var bool = false
    @State private var bool2 = false

    var body: some View {
        NavigationView {
            VStack {
                
                ZStack {
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Border
                        )
                        
                    
                    // Custom Tab Switcher
                    HStack() {
                        
                        // Login Tab
                        Button(action: {
                            selectedTab = 0
                        }) {
                            Text("Sign Up")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(selectedTab == 0 ? Color("ColorGreen") : Color.clear) // Selected background
                                .foregroundColor(selectedTab == 0 ? .white : Color("FontColor") ) // Text color
                                .cornerRadius(8)
                                
                        }

                        // Signup Tab
                        Button(action: {
                            selectedTab = 1
                        }) {
                            Text("Log In")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(selectedTab == 1 ? Color("ColorGreen") : Color.clear) // Selected background
                                .foregroundColor(selectedTab == 1 ? .white : Color("FontColor") ) // Text color
                                .cornerRadius(8)
                                
                        }
                    } // hstack

                } // zstack
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 32)
                
                Text("Getting Started !")
                    .font(.custom("Tajawal-Bold", size: 30))
                    .padding(.bottom, 32)
                    .foregroundColor(Color("DarkBlue"))

                // Dynamic Content
                if selectedTab == 0 {
                    SignUp() // Signup View
                    
                } else {
                    LogIn() //  Login View
                }

                Spacer()
                
                
            }
            .navigationTitle("")
            .navigationBarHidden(true)

        }
    }
}

#Preview {
    LoginSignupView()
}
