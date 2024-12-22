//
//  Getting_Started.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct Getting_Started: View {
    var body: some View {
        
        ZStack(){
            Image("Mask4")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            VStack(){
                Spacer()
                
                Text("ابدأ الآن")
                    .foregroundColor(Color("DarkBlue"))
                    .font(Font.custom("Tajawal-Bold", size: 40))
                
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, 20)
                
                Spacer()
                
                
                
//                NavigationLink(destination: LogIn()) {
//                    Text("تسجيل دخول")
//                        .font(Font.custom("Tajawal-Bold", size: 20))
//                        .foregroundColor(.white)
//                        .frame(width: 337, height: 30)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color("DarkBlue"))
//                        .cornerRadius(12)
//                        .shadow(radius: 7, x: 0, y: 5)
//                }
//                
//                NavigationLink(destination: SignUp()) {
//                    Text("إنشاء حساب")
//                        .font(Font.custom("Tajawal-Bold", size: 20))
//                        .foregroundColor(Color("DarkBlue"))
//                        .frame(width: 337, height: 30)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color("LightBlue"))
//                        .cornerRadius(12)
//                        .shadow(radius: 7, x: 0, y: 5)
//                }
                
                Spacer()
                
            }// vstack
            
        }
        
        
    }
}

#Preview {
    Getting_Started()
}
