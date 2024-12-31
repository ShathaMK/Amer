//
//  SignIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import CloudKit
import FirebaseAuth
import Combine

struct SignUp: View {
    
    @StateObject private var userVM = UserViewModel()
    
    
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    
    @State private var isShowingOTPView = false
    @State private var errorMessage: String? // Error messages to display
    @State private var isVerificationSent: Bool = false

    var body: some View {
        
        VStack() {
            
            
            Text("Name")
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            // Allow the user to enter their name
            TextField("Enter Your Name", text: $userVM.userName)
                .font(.custom("Tajawal-Medium", size: 20))
                .multilineTextAlignment(.leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .padding(.horizontal, 20)
                .onTapGesture {
                    userVM.hideKeyboard()
                }
            
            
            
            Spacer().frame(height: 32)
            
            // MARK: - phone number
            
            Text("Phone Number")
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack{
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // The button to toggle dropdown
                    Button(action: {
                        withAnimation {
                            isExpanded2.toggle()
                        }
                    }) {
                        HStack {
                            Text(userVM.selectedCountry?.flag ?? userVM.defaultCountry.flag)
                                .font(.custom("Tajawal-Bold", size: 20))
                                .foregroundColor(Color("FontColor"))
                            Text(userVM.selectedCountry?.code ?? userVM.defaultCountry.code)
                                .font(.custom("Tajawal-Bold", size: 20))
                                .foregroundColor(Color("FontColor"))
                            
                        }
                        .font(.custom("Tajawal-Medium", size: 20))
                        .frame(width: 77, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    } // end button
                    
                    
                } // end vstack
                .sheet(isPresented:  $isExpanded2) {
                    countrySheet(
                        selectedCountry: $userVM.selectedCountry,
                        countries: userVM.countries
                    )
                    .font(.custom("Tajawal-Bold", size: 20))
                    .foregroundColor(Color("FontColor"))
                    .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.visible)
                    
                }
                
                
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .font(.custom("Tajawal-Medium", size: 20))
                    .keyboardType( .phonePad)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    .onTapGesture {
                        userVM.hideKeyboard()
                    }
                
            } // end hstack
            .padding(.horizontal, 20)
            .onTapGesture {
                userVM.hideKeyboard()
            }
            
            
            Spacer().frame(height: 32)
            
            
            // MARK: - the drop down for the role
                
            Text("Role")
                .foregroundColor(Color("FontColor"))
                .font(.custom("Tajawal-Bold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            // Button to show/hide the list
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(userVM.selectedRole.isEmpty ? "Select a role" : userVM.selectedRole) // Show placeholder if no role is selected
                        .foregroundColor(userVM.selectedRole.isEmpty ? .gray : .primary) // Placeholder color
                        .font(.custom("Tajawal-Medium", size: 20))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color("ColorBlue"))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .padding(.horizontal, 20)
            }
            
            // The dropdown list
            if isExpanded {
                ForEach(userVM.roles, id: \.self) { role in
                    Button(action: {
                        userVM.selectedRole = role
                        withAnimation {
                            isExpanded = false
                        }
                    }) {
                        Text(role)
                            .font(.custom("Tajawal-Medium", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color("FontColor"))
                    }
                    .padding(.horizontal, 20)
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .padding(.horizontal, 20)
                }
            }
                
            
            
            Spacer()
            
            if let errorMessage = userVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            

            Button("Send"){
                userVM.sendVerificationCode()
                isShowingOTPView.toggle()
            }
            .buttonStyle(GreenButton())
            .shadow(radius: 7, x: 0, y: 5)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $isShowingOTPView) {
//                OTP_view(phoneNumber: userVM.selectedCountry!.code + userVM.phoneNumber)
//                OTP_view(phoneNumber: userVM.selectedCountry!.code + userVM.phoneNumber, verificationID: "666")
                OTP_view(userVM: userVM)
                
            }
            
            
            
            
        } // end vstack
        .onTapGesture {
            userVM.hideKeyboard()
        }
        
        
        
    }
    
    
    
   
    
}



#Preview {
    SignUp()
}
