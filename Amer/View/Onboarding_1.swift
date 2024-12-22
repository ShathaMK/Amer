//
//  Onboarding_1.swift
//  Amer
//
//  Created by Noori on 15/12/2024.
//

import SwiftUI

struct Onboarding_1: View {
    
    
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
                    

                    
//                    Button(action: {
//                        print("Full-width button tapped!")
//                    }) {
//                        Text("Submit")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.green)
//                            .cornerRadius(10)
//                    }

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
                    
                    HStack(){
                        Circle()
                            .fill(Color("ColorGreen"))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                    }
                    .padding(.leading, 170)
                    
                    Spacer()
                    
                    NavigationLink(destination: Onboarding_2()) {
                        Text("Next")
                            .font(Font.custom("Tajawal-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("ColorGreen"))
                            .cornerRadius(12)
                            .shadow(radius: 7, x: 0, y: 5)
                            
                            
                    }
                    .padding(.trailing, 50)
                    
                }
                .padding(.top, 90)
                    
                
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
