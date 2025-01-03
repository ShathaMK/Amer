//
//  LogIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import FirebaseAuth

struct LogIn: View {
    
    @StateObject private var userVM = UserViewModel()
    @State private var isExpanded2: Bool = false // sheet bool
    @State private var isShowingOTPView = false
    
    
    var body: some View {
        
        
        VStack {
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
                    .keyboardType( .numberPad)
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
            
            Spacer()

             Button("Send"){
                 userVM.sendVerificationCode()
                 isShowingOTPView.toggle()
             }
             .buttonStyle(GreenButton())
             .shadow(radius: 7, x: 0, y: 5)
             .padding(.horizontal, 20)
             .fullScreenCover(isPresented: $isShowingOTPView) {
                 OTP_view(userVM : userVM)
//                 OTP_view(userVM : userVM, phoneNumber: userVM.selectedCountry!.code + userVM.phoneNumber)
//                 OTP_view(phoneNumber: userVM.selectedCountry!.code + userVM.phoneNumber)
             }
             .disabled(userVM.phoneNumber.isEmpty)
                         
            
            
           
       } // end big vstack
        .onTapGesture {
            userVM.hideKeyboard()
        }
        
        
        
        
    }
}

#Preview {
    LogIn()
}
