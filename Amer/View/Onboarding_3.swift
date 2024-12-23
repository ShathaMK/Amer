//
//  Onboarding_3.swift
//  Amer
//
//  Created by Noori on 19/12/2024.
//

import SwiftUI

struct Onboarding_3: View {
    
    @State private var bool = false
    
    
    var body: some View {
        
        
        ZStack(){
            Image("Mask3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(){
                
                Button("Skip") {
                    bool = true
                }
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(.gray)
                .padding(.leading, 250)
                .padding(.top, 60)
                .fullScreenCover(isPresented: $bool) {
                    Getting_Started()
                }
                
                
                Spacer()
                
                
                Text("Your Wish is Our Command")
                    .font(Font.custom("Tajawal-Bold", size: 40))
                    .multilineTextAlignment(.center)

                    
                
                // Adding the GIFImage in the center
                GIFImage(name: "handshake")
                    .frame(width: 340, height: 292)
                    .shadow(radius: 3, x: 13, y: 0)
                    .padding(.bottom, 40)
                    .padding(.top, -30)
                    .padding(.leading, 70)
                
                Text("Just press the button, and help will rush to you !")
                    .font(Font.custom("Tajawal-Bold", size: 22))
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center) // Center alignment

                    
                
                HStack(){
                    Spacer()
                    
                    Text("3/3")
                        .padding(.trailing, 50)
                        .font(.custom("Tajawal-Bold", size: 20))
                        .foregroundColor(.gray)
                    
                    
                    Button("Next") {
                        bool = true
                    }
                    .font(.custom("Tajawal-Bold", size: 20))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .background( Color("ColorGreen") )
                    .cornerRadius(12)
                    .shadow(radius: 7, x: 0, y: 5)
                    .fullScreenCover(isPresented: $bool) {
                        Onboarding_3()
                    }
                    .padding(.trailing, 50)
                    
                }
                .padding(.top, 70)
                    
                
                Spacer()
            }
        }
        
        
    }
}

#Preview {
    Onboarding_3()
}
