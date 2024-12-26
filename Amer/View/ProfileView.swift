//
//  ProfileView.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.
import SwiftUI
import UIKit
struct ProfileView: View {
    @State private var selectedFontSize = "Medium" // Default font size selection
    @State private var isHapticsEnabled = true // State for Haptics toggle

    var body: some View {

        NavigationStack {
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Rectangle()
                        .frame(width: 393, height: 644)
                        .foregroundColor(Color.white)
                        .ignoresSafeArea(.all)
                        .cornerRadius(52)
                        .padding(.top,150)
                        .overlay(
                            Image("profile_logo")
                                .padding(.top, -299)
                        )
                    
                    VStack(spacing: 15) {
                        Text("Mohammad Saleh")
                            .font(.custom("Tajawal-Bold", size: 30))
                            .foregroundStyle(Color("FontColor"))
                        Text("+96650789644")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundStyle(Color("FontColor"))
                    }
                    .padding(.bottom, 270)
                    
                    VStack(spacing: -3) {
                        HStack {
                            Text("Edit Profile")
                                .font(.headline)
                                .font(.custom("Tajawal-Bold", size: 16))
                                .foregroundStyle(Color("DarkBlue"))
                                .padding(.trailing, 200)
                            Image("EditSymbol")
                        }
                        .padding()
                        .frame(width: 377, height: 60)
                        .background(Color("VLightBlue"))
                        .cornerRadius(10)
                        Divider()
                            .frame(minHeight: 1)
                            .overlay(Color("LightBlue"))
                            .frame(width: 377)
                            .padding(.top, -5)
                        
                        HStack {
                            Text("Font Size")
                                .font(.headline)
                                .font(.custom("Tajawal-Bold", size: 16))
                                .foregroundStyle(Color("DarkBlue"))
                                .padding(.trailing, 150)
                            
                            // Dropdown List (Menu)
                            Menu {
                                Button(action: {
                                    selectedFontSize = "Small"
                                }) {
                                    Text("Small")
                                }
                                Button(action: {
                                    selectedFontSize = "Medium"
                                }) {
                                    Text("Medium")
                                }
                                Button(action: {
                                    selectedFontSize = "Large"
                                }) {
                                    Text("Large")
                                }
                            } label: {
                                HStack {
                                    Text(selectedFontSize)
                                        .font(.custom("Tajawal-Bold", size: 16))
                                        .foregroundStyle(Color("DarkBlue"))
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(Color("DarkBlue"))
                                }
                                .padding(10)
                                .background(Color("VLightBlue"))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .frame(width: 377, height: 60)
                        .background(Color("VLightBlue"))
                        .cornerRadius(10)
                        
                        Divider()
                            .frame(minHeight: 1)
                            .overlay(Color("LightBlue"))
                            .frame(width: 377)
                            .padding(.top, -5)
                        
                        HStack {
                            Toggle(isOn: $isHapticsEnabled) {
                                Text("Haptics")
                                    .font(.headline)
                                    .font(.custom("Tajawal-Bold", size: 16))
                                    .foregroundStyle(Color("DarkBlue"))
                                    .padding(.leading, 10)
                            }
                        }
                        .padding()
                        .frame(width: 377, height: 60)
                        .background(Color("VLightBlue"))
                        .cornerRadius(10)
                        
                        Image("MembersButton")
                            .padding(.top, 50)
                    }
                    .padding(.top, 220)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: Onboarding_1()) {
                        HStack {
                            Image("ArrowLeft")
                                .frame(width: 50, height: 50)
                                .padding(.top, 50)
                            
                            Text("Profile")
                                .foregroundColor(Color.white)
                                .font(.custom("Tajawal-Bold", size: 30))
                                .padding(.leading, 78)
                                .padding(.top, 60)
                           
                        }
                    }
                }
            }
            
        }



    }
}

#Preview {
    ProfileView()
}
