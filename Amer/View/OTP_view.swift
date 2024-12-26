//
//  OTP_view.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct OTP_view: View {
    
    @StateObject private var userVM = UserViewModel()
    @FocusState private var focusedIndex: Int? // Tracks which text field is focused
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Enter OTP")
                .font(Font.custom("Tajawal-Bold", size: 40))
                .multilineTextAlignment(.center)
                .padding(.top, 60)
            
            
            Spacer()
                .frame(height: 24)
            
            
            
            Image("sms")
                .resizable()
                .frame(width: 142.85, height: 169.31)
                .padding(.leading, 50)
            
            
            
            Spacer()
                .frame(height: 24)
            
            
            
            Text("OTP will be sent to this number 501234567 ")
                .font(Font.custom("Tajawal-Bold", size: 16))
                .foregroundStyle(Color.gray)
            
            
            
            
            
            
            Spacer()
            
            
            
            Button("Send"){
                print("it works")
            }
            .buttonStyle(BlueButton())
            .padding()
            
//            Spacer()
            
        }
        
    }
}

#Preview {
    OTP_view()
}
