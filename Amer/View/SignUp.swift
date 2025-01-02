//
//  SignUp.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import CloudKit
import FirebaseAuth
import Combine

struct SignUp: View {
    @StateObject var userVM = UserViewModel()
    @State private var isExpanded: Bool = false // Dropdown state
    @State private var isExpanded2: Bool = false // Sheet state
    
    @State private var isShowingOTPView = false
    @State private var showErrorAlert = false // To display error messages
    
    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            
            Text("Getting Started!")
                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                .padding(.bottom, 32)
                .foregroundColor(Color("DarkBlue"))
            
            Spacer().frame(height: 32)
            
            // MARK: - Name Input
            Text("Name")
                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            TextField("Enter Your Name", text: $userVM.name)
                .font(Font.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                .multilineTextAlignment(.leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .padding(.horizontal, 20)
                .onTapGesture {
                    userVM.hideKeyboard()
                }
            
            Spacer().frame(height: 32)
            
            // MARK: - Phone Number Input
            Text("Phone Number")
                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        withAnimation {
                            isExpanded2.toggle()
                        }
                    }) {
                        HStack {
                            Text(userVM.selectedCountry?.flag ?? userVM.defaultCountry.flag)
                                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                .foregroundColor(Color("FontColor"))
                            Text(userVM.selectedCountry?.code ?? userVM.defaultCountry.code)
                                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                .foregroundColor(Color("FontColor"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    }
                }
                .sheet(isPresented: $isExpanded2) {
                    countrySheet(
                        selectedCountry: $userVM.selectedCountry,
                        countries: userVM.countries
                    )
                    .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                    .foregroundColor(Color("FontColor"))
                    .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.visible)
                }
                
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .font(Font.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                    .keyboardType(.phonePad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    .onTapGesture {
                        userVM.hideKeyboard()
                    }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 32)
            
            // MARK: - Role Selection Dropdown
            Text("Role")
                .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(userVM.selectedRole.isEmpty ? "Select a role" : userVM.selectedRole)
                        .foregroundColor(userVM.selectedRole.isEmpty ? .gray : .primary)
                        .font(Font.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("ColorBlue"))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .padding(.horizontal, 20)
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    ForEach(userVM.roles, id: \.self) { role in
                        Button(action: {
                            userVM.triggerHapticFeedback() // Haptic feedback for selection
                            userVM.selectedRole = role
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(role)
                                .font(Font.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                                .padding()
                        }
                        if role != userVM.roles.last {
                            Divider().padding(.horizontal)
                        }
                    }
                }
                .transition(.opacity)
                .padding(.horizontal, 20)
            }
            
            Spacer()
            

            // MARK: - Send Button
            Button(action: {
                userVM.triggerHapticFeedback() // Haptic feedback
                guard !userVM.name.isEmpty, !userVM.phoneNumber.isEmpty, !userVM.selectedRole.isEmpty else {
                    userVM.errorMessage = "Please fill in all fields before proceeding."
                    showErrorAlert = true
                    return
                }
                
                userVM.checkUserExists { exists, error in
                    if let error = error {
                        userVM.errorMessage = "Error checking user: \(error.localizedDescription)"
                        showErrorAlert = true
                    } else if exists {
                        userVM.errorMessage = "User already exists. Redirecting to login..."
                        showErrorAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isShowingOTPView.toggle()
                        }
                    } else {
                        userVM.sendVerificationCode { success in
                            if success {
                                userVM.saveUserToCloud { result in
                                    switch result {
                                    case .success:
                                        isShowingOTPView.toggle()
                                    case .failure(let error):
                                        userVM.errorMessage = "Failed to save user: \(error.localizedDescription)"
                                        showErrorAlert = true
                                    }
                                }
                            } else {
                                userVM.errorMessage = "Failed to send OTP. Please try again."
                                showErrorAlert = true
                            }
                        }
                    }
                }
            }) {
                Text("Send")
                    .font(Font.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                    .foregroundColor(.white)

            if let errorMessage = userVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            
          
            }
            .buttonStyle(GreenButton())
            .shadow(radius: 7, x: 0, y: 5)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $isShowingOTPView) {
                if userVM.errorMessage == "User already exists. Redirecting to login..." {
                    LoginSignupView(selectedTab: 1)
                } else {
                    OTP_view()
                }
            }

            
        } // end vstack

        .onTapGesture {
            userVM.hideKeyboard()
        }
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
    SignUp()
}
