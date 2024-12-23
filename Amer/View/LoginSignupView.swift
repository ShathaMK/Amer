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
            VStack {
                ZStack {
                    Rectangle()
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        .frame(height: 50)
                        .foregroundColor(Color("ColorLightGray"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Border
                        )
                        
                    
                    // Custom Tab Switcher
                    HStack() {
                        
                        // Login Tab
                        Button(action: {
                            selectedTab = 0
                        }) {
                            Text("تسجيل دخول")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(selectedTab == 0 ? Color("ColorGreen") : Color.white) // Selected background
                                .foregroundColor(selectedTab == 0 ? .white : .black) // Text color
    //                            .cornerRadius(10, corners: selectedTab == 0 ? [.topLeft, .bottomLeft] : [])
                                .cornerRadius(8)
                                
                        }

                        // Signup Tab
                        Button(action: {
                            selectedTab = 1
                        }) {
                            Text("حساب جديد")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .frame(maxWidth: .infinity)
//                                .frame(width: 200)
                                .padding(.vertical, 14)
                                .background(selectedTab == 1 ? Color("ColorGreen") : Color.white) // Selected background
                                .foregroundColor(selectedTab == 1 ? .white : .black) // Text color
    //                            .cornerRadius(10, corners: selectedTab == 1 ? [.topRight, .bottomRight] : [])
                                .cornerRadius(8)
                                
                        }
                    } // hstack

                } // zstack
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 64)
                
                
                
                // Dynamic Content
                if selectedTab == 0 {
                    LogIn() // Login View
                } else {
                    SignUp() // Signup View
                }

                Spacer()
                
                
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color.white.ignoresSafeArea())
        }
    }
}

#Preview {
    LoginSignupView()
}
