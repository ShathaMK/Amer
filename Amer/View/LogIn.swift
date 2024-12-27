//
//  LogIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct LogIn: View {
    
    @State private var bool = false
    
    var body: some View {
        
        
        VStack {
           Text("Phone Number")
               .font(.custom("Tajawal-Bold", size: 20))
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding(.horizontal)

           HStack {
               Text("🇸🇦") // Replace with your flag asset
                   .frame(width: 30, height: 20)

               Text("+966")
                   .font(.custom("Tajawal-Regular", size: 20))

               TextField("501234567", text: .constant(""))
                   .keyboardType(.numberPad)
                   .multilineTextAlignment(.leading)
                   .padding(.horizontal)
           }
           .padding()
           .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
           .padding(.horizontal, 20)

            Spacer()

             Button("Send"){
                 
             }
             .buttonStyle(GreenButton())
             .padding(.horizontal, 20)
             .fullScreenCover(isPresented: $bool) {
                 OTP_view()
             }
           
       }
        
        
    }
}

#Preview {
    LogIn()
}
