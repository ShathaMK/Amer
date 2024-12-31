//
//  ProfileView.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.

import SwiftUI
import UIKit

struct ProfileView: View {
    @StateObject private var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    
    @State private var bool = false
    
    
    @State private var selectedFontSize = "Medium" // Default font size selection
    @State private var isHapticsEnabled = true // State for Haptics toggle
    @EnvironmentObject var fontSizeManager: FontSizeManager
    
    var body: some View {
//        "Assistant", "Reciver"
        NavigationStack {
            
            ZStack {
                Color("DarkBlue")
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    
                    Spacer()
                    
                    VStack{
                        Text("Mohammad Saleh")
                            .font(.custom("Tajawal-Bold", size: 30))
                            .foregroundStyle(Color("FontColor"))
                        Text("+96650789644")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundStyle(Color("FontColor"))
                    }
                    .padding(.top, -180)
                    
//                    Spacer()
//                        .frame(height: 32)
                    
                    
                    HStack(){
                        Slider(value: $userVM.fontSize, in: 12...24, step: 1) {
                            Text("Font Size")
                                .font(.custom("Tajawal-Bold", size: CGFloat(userVM.fontSize)))
                        }
                        
                    }
                    .padding(.horizontal)
                    Text("Font Size: \(Int(userVM.fontSize))")
                        .font(.system(size: CGFloat(userVM.fontSize)))
                    
                    
                    HStack(){
                        
                        Text("Edit Profile")
                           .font(.custom("Tajawal-Bold", size: 16))
                           .foregroundStyle(Color("DarkBlue"))
                           .padding(.leading)
                        
                        Spacer()
                        
                        Image("EditSymbol")

                    }
                    .padding()
                    
                    Spacer()
//                    Form {
//                        // Font Size Section
//                        Section(header: Text("Font Size")) {
//                            Slider(value: $userVM.fontSize, in: 12...24, step: 1) {
//                                Text("Font Size")
//                                    .font(.custom("Tajawal-Bold", size: userVM.fontSize))
//                            }
//                            Text("Font Size: \(Int(userVM.fontSize))")
//                                .font(.system(size: CGFloat(userVM.fontSize)))
//                        }
//                        
//                        // Haptics Section
//                        Section(header: Text("Haptics")) {
//                            Toggle("Enable Haptics", isOn: $userVM.hapticsEnabled)
//                        }
//                        
//                        // Profile Section
//                        Section(header: Text("Profile")) {
//                            NavigationLink(destination: EditProfileView()) {
//                                HStack {
//                                    Text("Edit Profile")
////                                    Spacer()
////                                    Image(systemName: "chevron.down")
////                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                        
//                    } // end form
                }
                .frame(maxWidth: .infinity)
                .frame(height: 680)
                .background(Color("VLightBlue"))
                .cornerRadius(52)
                .padding(.top, 80)
                
                
                if(userVM.selectedRole == "Assistant"){
                    Image("User_Assistant")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                    
                }else{
                    Image("User_Reciver")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                }
                
                
            }
            
            .onTapGesture {
                userVM.hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .foregroundColor(Color.white)
                        .font(.custom("Tajawal-Bold", size: 30))
                }

            }
        }
        
        
        

//        NavigationStack {
//            ZStack {
//                Color.darkBlue
//                    .edgesIgnoringSafeArea(.all)
//                
//                ZStack {
//                    Rectangle()
//                        .frame(width: 393, height: 644)
//                        .foregroundColor(Color.white)
//                        .ignoresSafeArea(.all)
//                        .cornerRadius(52)
//                        .padding(.top,150)
//                        .overlay(
//                            Image("profile_logo")
//                                .padding(.top, -299)
//                        )
//                    
//                    VStack(spacing: 15) {
//                        Text("Mohammad Saleh")
//                            .font(.custom("Tajawal-Bold", size: 30))
//                            .foregroundStyle(Color("FontColor"))
//                        Text("+96650789644")
//                            .font(.custom("Tajawal-Bold", size: 20))
//                            .foregroundStyle(Color("FontColor"))
//                    }
//                    .padding(.bottom, 270)
//                    
//                    VStack(spacing: -3) {
//                       
//                            HStack {
//                                Text("Edit Profile")
//                                    .font(.headline)
//                                    .font(.custom("Tajawal-Bold", size: 16))
//                                    .foregroundStyle(Color("DarkBlue"))
//                                    .padding(.trailing, 200)
//                                Button {
//                                    
//                                } label: {
//                                Image("EditSymbol")
//                            }
//                        }
//                        .padding()
//                        .frame(width: 377, height: 60)
//                        .background(Color("VLightBlue"))
//                        .cornerRadius(10)
//                        Divider()
//                            .frame(minHeight: 1)
//                            .overlay(Color("LightBlue"))
//                            .frame(width: 377)
//                            .padding(.top, -5)
//                        
//                        HStack {
//                            Text("Font Size")
//                                .font(.headline)
//                                .font(.custom("Tajawal-Bold", size: 16))
//                                .foregroundStyle(Color("DarkBlue"))
//                                .padding(.trailing, 150)
//                            
//                            // Dropdown List (Menu)
//                            Menu {
//                                Button(action: {
//                                    selectedFontSize = "Small"
//                                }) {
//                                    Text("Small")
//                                }
//                                Button(action: {
//                                    selectedFontSize = "Medium"
//                                }) {
//                                    Text("Medium")
//                                }
//                                Button(action: {
//                                    selectedFontSize = "Large"
//                                }) {
//                                    Text("Large")
//                                }
//                            } label: {
//                                HStack {
//                                    Text(selectedFontSize)
//                                        .font(.custom("Tajawal-Bold", size: 16))
//                                        .foregroundStyle(Color("DarkBlue"))
//                                    Image(systemName: "chevron.down")
//                                        .foregroundStyle(Color("DarkBlue"))
//                                }
//                                .padding(10)
//                                .background(Color("VLightBlue"))
//                                .cornerRadius(10)
//                            }
//                        }
//                        .padding()
//                        .frame(width: 377, height: 60)
//                        .background(Color("VLightBlue"))
//                        .cornerRadius(10)
//                        
//                        Divider()
//                            .frame(minHeight: 1)
//                            .overlay(Color("LightBlue"))
//                            .frame(width: 377)
//                            .padding(.top, -5)
//                        
//                        HStack {
//                            Toggle(isOn: $isHapticsEnabled) {
//                                Text("Haptics")
//                                    .font(.headline)
//                                    .font(.custom("Tajawal-Bold", size: 16))
//                                    .foregroundStyle(Color("DarkBlue"))
//                                    .padding(.leading, 10)
//                            }
//                            .onChange(of: isHapticsEnabled) {
//                                                      // Trigger haptic feedback when the toggle is changed
//                            HapticFeedback.shared.triggerHapticFeedback()
//                            }
//                        }
//                        
////                        HStack {
////                            Toggle(isOn: $isHapticsEnabled) {
////                                Text("Haptics")
////                                    .font(.headline)
////                                    .font(.custom("Tajawal-Bold", size: 16))
////                                    .foregroundStyle(Color("DarkBlue"))
////                                    .padding(.leading, 10)
////                            }
////                        }
//                        .padding()
//                        .frame(width: 377, height: 60)
//                        .background(Color("VLightBlue"))
//                        .cornerRadius(10)
//                        
//                        
//                        Button {
//                            
//                        } label: {
//                            HStack {
//                                Text("Members")
//                                    .padding()
//                                Spacer()
//                                Image(systemName: "person.2.fill")
//                                    .foregroundStyle(Color.white)
//                                    .padding()
//                            }
//                        }
//                        .buttonStyle(GreenButton())
//                        .padding()
//                        .padding(.top, 40)
//                        
//                    }
//                    .padding(.top, 220)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: Onboarding_1()) {
//                        HStack {
//                            Image("ArrowLeft")
//                                .frame(width: 50, height: 50)
//                                .padding(.top, 50)
//                            
//                            Text("Profile")
//                                .foregroundColor(Color.white)
//                                .font(.custom("Tajawal-Bold", size: 30))
//                                .padding(.leading, 78)
//                                .padding(.top, 60)
//                           
//                        }
//                    }
//                }
//            }
//            
//        }
        
        
        
        
        
    }
}

#Preview {
    ProfileView()
}


