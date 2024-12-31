
//  LogIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct LogIn: View {
    
    @StateObject private var userVM = UserViewModel()
    @State private var isExpanded2: Bool = false // sheet bool

    @State private var bool = false
    
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
                .onTapGesture {
                    userVM.hideKeyboard()
                }
                
                
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .font(.custom("Tajawal-Medium", size: 20))
                    .keyboardType( .numberPad)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                
                
            } // end hstack
            .padding(.horizontal, 20)
            .onTapGesture {
                userVM.hideKeyboard()
            }
            
            Spacer()
            
            // MARK: - sending button

             Button("Send"){
                 bool.toggle()
             }
             .buttonStyle(GreenButton())
             .padding(.horizontal, 20)
             .fullScreenCover(isPresented: $bool) {
                 OTP_view(phoneNumber: userVM.selectedCountry!.code + userVM.phoneNumber)
             }
           
       } // end vstack
        
        
    }
}

#Preview {
    LogIn()
}
