//
//  Onboarding_1.swift
//  Amer
//
//  Created by Noori on 15/12/2024.
//

import SwiftUI

struct Onboarding_1: View {
    
    @State private var bool = false
    
    var body: some View {
        
        
        ZStack(){
            Image("Mask1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(){
                
                // Top bar with Skip button
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: Getting_Started()) {
                        Text("Skip")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 50)

                }
                .padding(.top, 50)
                
                
                Spacer()
                
                
                Text("Customize Support")
                    .font(Font.custom("Tajawal-Bold", size: 40))

                    
                
                // Adding the GIFImage in the center
                GIFImage(name: "wheelchair")
                    .frame(width: 269, height: 292)
                    .shadow(radius: 3, x: 13, y: 0)
                    .padding(.bottom, 20)
                
                Text("Empower their independence with tools that adapt to them.")
                    .font(Font.custom("Tajawal-Bold", size: 22))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center) // Center alignment

                    
                HStack(){
                    Spacer()
                    
                    Text("1/3")
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
                        Onboarding_2()
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
//    Onboarding_1()
    
    NavigationStack {
            Onboarding_1()
        }
}
