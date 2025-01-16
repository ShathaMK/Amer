//
//  ProfileView.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//


import SwiftUI
import UIKit
import Firebase
import FirebaseAuth

struct ProfileView: View {
//    @StateObject var userVM = UserViewModel() // For dynamic font scaling and haptics
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var showErrorAlert = false // State to control alert visibility

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color("DarkBlue")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(height: 70)
                    
                    // User Info Section
                    VStack {
                        Text(userVM.name.isEmpty ? "Loading..." : userVM.name)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                            .foregroundStyle(Color("FontColor"))

                        Text(userVM.phoneNumber.isEmpty ? "Loading..." : userVM.phoneNumber)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("FontColor"))
                    }
                    .onAppear {
                       
                        
                    }

                    Spacer()
                        .frame(height: userVM.scaledFont(baseSize: 50))
                    
                    // Font Size Section
                    HStack {
                        Text("Font Size")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("DarkBlue"))
                            
                        Spacer()
                        
                        Slider(value: $userVM.fontSize, in: 12...24, step: 1) {
                            Text("Font Size")
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                        }
                        .frame(width: 250)
                        .onChange(of: userVM.fontSize) { _ in
                            userVM.triggerHapticFeedback()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: userVM.scaledFont(baseSize: 32))
                    
                    Text("Font Size: \(Int(userVM.fontSize))")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                    
                    Divider()
                        .padding()
                    
                    // Edit Profile Navigation
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Text("Edit Profile")
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
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
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("DarkBlue"))
                            .onChange(of: userVM.isHapticsEnabled) { _ in
                                userVM.triggerHapticFeedback()
                            }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Members Navigation
                    NavigationLink(destination: MembersView()
                        .environmentObject(buttonsVM)
                        .environmentObject(userVM)) {
                        HStack {
                            Text("Members")
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                .foregroundStyle(Color.white)
                            
                            Spacer()
                            
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(Color.white)
                        }
                        .padding()
                    }
                    .buttonStyle(GreenButton())
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: userVM.scaledFont(baseSize: 50))
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
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                }
            }
        }
        .onAppear(){
            // 1) Check if there's a logged-in Firebase user
               if let currentUser = Auth.auth().currentUser {
                   let phone = currentUser.phoneNumber ?? ""
                   
                   // 2) Fetch from CloudKit using that phone
                   userVM.fetchUserData(forPhoneNumber: phone) { success in
                       if success {
                           // userVM.name, userVM.phoneNumber, userVM.selectedRole are now set
                           print("Fetched user from CloudKit for phone: \(phone)")
                       } else {
                           // userVM.errorMessage might contain details
                           print("Failed to fetch user or not found.")
                       }
                   }
               } else {
                   // Not logged in via Firebase
                   print("No current user. Please log in.")
               }
        }
        // Alert to show errors
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(userVM.errorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
}
