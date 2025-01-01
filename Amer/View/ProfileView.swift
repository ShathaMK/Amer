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
    
    @State private var bool: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color("DarkBlue")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(height: 64)
                    
                    // User Info Section
                    VStack {
                        Text(userVM.name)
                            .font(.custom("Tajawal-Bold", size: 30))
                            .foregroundStyle(Color("FontColor"))
                        
                        Text(userVM.phoneNumber)
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundStyle(Color("FontColor"))
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    // Font Size Section
                    HStack {
                        Text("Font Size")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundStyle(Color("DarkBlue"))
                            
                        Spacer()
                        
                        Slider(value: $userVM.fontSize, in: 12...24, step: 1) {
                            Text("Font Size")
                                .font(.custom("Tajawal-Bold", size: CGFloat(userVM.fontSize)))
                        }
                        .frame(width: 250)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Text("Font Size: \(Int(userVM.fontSize))")
                        .font(.custom("Tajawal-Bold", size: CGFloat(userVM.fontSize)))
                    
                    Divider()
                        .padding()
                    
                    // Edit Profile Navigation
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Text("Edit Profile")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .foregroundStyle(Color("DarkBlue"))
                            
                            Spacer()
                            
                            Image("EditSymbol")
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    Divider()
                        .padding()
                    
                    // Enable Haptics Toggle
                    HStack {
                        Toggle("Haptics", isOn: $userVM.isHapticsEnabled)
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundStyle(Color("DarkBlue"))
                            .onChange(of: userVM.isHapticsEnabled) { newValue in
                                if newValue {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                }
                            }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                    
                    // Members Button
                    Button {
                        bool.toggle()
                        
                    } label: {
                        HStack {
                            Text("Members")
                                .padding()
                            Spacer()
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(Color.white)
                                .padding()
                        }
                    }
                    .buttonStyle(GreenButton())
                    .padding()
                    
                    
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 680)
                .background(Color("VLightBlue"))
                .cornerRadius(52)
                .padding(.top, 80)
                
                // Role-based Image
                if userVM.selectedRole == "Assistant" {
                    Image("User_Assistant")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                } else if userVM.selectedRole == "Reciver" {
                    Image("User_Reciver")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                } else {
                    Image(systemName: "person.crop.circle") // Default profile image
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                }
                
            }
            .onTapGesture {
                userVM.hideKeyboard()
            }
            .navigationBarBackButtonHidden(true)
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
    }
}

#Preview {
    ProfileView()
}
