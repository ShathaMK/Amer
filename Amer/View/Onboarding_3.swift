//
//  Onboarding_3.swift
//  Amer
//
//  Created by Noori on 19/12/2024.
//

import SwiftUI

struct Onboarding_3: View {
    
    @State private var bool = false
    @State private var bool2 = false
    
    var body: some View {
        
        
        ZStack(){
            Image("Mask3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(){
                
                Spacer()
                
                
                Text("Your Wish is Our Command")
                    .font(Font.custom("Tajawal-Bold", size: 40))
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                    
                
                // Adding the GIFImage in the center
                GIFImage(name: "handshake")
                    .frame(width: 340, height: 292)
                    .shadow(radius: 3, x: 13, y: 0)
                    .padding(.bottom, 40)
                    .padding(.top, -30)
                    .padding(.leading, 70)
                
                Text("Just press the button, and help will rush to you !")
                    .font(Font.custom("Tajawal-Bold", size: 22))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center) // Center alignment

                    
                Spacer()
                    .frame(height: 32)
                
                Button("Start Now") {
                    bool2 = true
                }
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(.white)
//                .frame(width: 110, height: 40)
                .background( Color("ColorGreen") )
                .cornerRadius(12)
                .shadow(radius: 7, x: 0, y: 5)
                .fullScreenCover(isPresented: $bool2) {
                    LoginSignupView()
                }

                
                Spacer()
                    .frame(height: 24)
                
                
                Text("3/3")
                    .font(.custom("Tajawal-Bold", size: 20))
                    .foregroundColor(.gray)

                

                
                Spacer()
            }
        }
        
        
    }
}

#Preview {
    Onboarding_3()
}
