//
//  Onboarding_3.swift
//  Amer
//
//  Created by Noori on 19/12/2024.
//

import SwiftUI

struct Onboarding_3: View {
    
    @StateObject var userVM = UserViewModel() // Dynamic font scaling and haptics
    
//    @EnvironmentObject var userVM = UserViewModel
    
    @State private var bool = false
    @State private var bool2 = false
    
    var body: some View {
        ZStack {
            Image("Mask3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Your Wish is Our Command")
                    .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 40)))
                    .multilineTextAlignment(.center)
                    .padding(.top, userVM.scaledFont(baseSize: 60))

                // Adding the GIFImage in the center
                GIFImage(name: "handshake")
                    .frame(width: 340, height: 292)
                    .shadow(radius: 3, x: 13, y: 0)
                    .padding(.bottom, userVM.scaledFont(baseSize: 40))
                    .padding(.top, userVM.scaledFont(baseSize: -30))
                    .padding(.leading, userVM.scaledFont(baseSize: 70))

                Text("Just press the button, and help will rush to you !")
                    .font(Font.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 22)))
                    .padding(.horizontal, userVM.scaledFont(baseSize: 30))
                    .multilineTextAlignment(.center) // Center alignment

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 50))

                Button("Start Now") {
                    bool2 = true
                    userVM.triggerHapticFeedback() // Trigger haptic feedback on tap
                }
                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: userVM.scaledFont(baseSize: 40))
                .background(Color("ColorGreen"))
                .cornerRadius(10)
                .shadow(radius: 7, x: 0, y: 5)
                .padding()
                .fullScreenCover(isPresented: $bool2) {
                    LoginSignupView()
                }

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 100))
            }
        }
    }
}

#Preview {
    Onboarding_3()
}
