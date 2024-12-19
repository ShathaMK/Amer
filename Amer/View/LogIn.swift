//
//  LogIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct LogIn: View {
    var body: some View {
        
        
        VStack {
                   Text("رقم الهاتف")
                       .font(.custom("Tajawal-Bold", size: 18))
                       .frame(maxWidth: .infinity, alignment: .trailing)
                       .padding(.horizontal)

                   HStack {
                       Image("saudi_flag") // Replace with your flag asset
                           .resizable()
                           .frame(width: 30, height: 20)
                           .clipShape(Rectangle())

                       Text("+966")
                           .font(.custom("Tajawal-Regular", size: 16))

                       TextField("501234567", text: .constant(""))
                           .keyboardType(.numberPad)
                           .multilineTextAlignment(.trailing)
                           .padding(.horizontal)
                   }
                   .padding()
                   .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                   .padding(.horizontal, 20)

                   Spacer()

                   // NavigationLink for "إرسال"
                   NavigationLink(destination: OTP_view()) {
                       Text("إرسال")
                           .font(.custom("Tajawal-Bold", size: 18))
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.blue)
                           .cornerRadius(10)
                   }
                   .padding(.horizontal, 20)
               }
        
        
    }
}

#Preview {
    LogIn()
}
