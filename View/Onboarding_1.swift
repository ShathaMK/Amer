//
//  Onboarding_1.swift
//  Amer
//
//  Created by Noori on 15/12/2024.
//

import SwiftUI

struct Onboarding_1: View {
    @StateObject var userVM = UserViewModel() // Dynamic font scaling and haptics
//    @EnvironmentObject var userVM = UserViewModel
    @State private var bool = false
    @State private var bool2 = false

    var body: some View {
        ZStack {
            Image("Mask1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Button("Skip") {
                    bool = true
                    userVM.triggerHapticFeedback() // Haptic feedback on tap
                }
                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                .foregroundColor(.gray)
                .padding(.leading, 250)
                .padding(.top, userVM.scaledFont(baseSize: 60))
                .fullScreenCover(isPresented: $bool) {
                    LoginSignupView()
                }

                Spacer()

                Text("Customize Support")
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 40)))

                // Adding the GIFImage in the center
                GIFImage(name: "wheelchair")
                    .frame(width: 269, height: 292)
                    .shadow(radius: 3, x: 13, y: 0)
                    .padding(.bottom, userVM.scaledFont(baseSize: 20))

                Text("Empower their independence with tools that adapt to them.")
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 22)))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                HStack {
                    Spacer()

                    Text("1/3")
                        .padding(.trailing, 50)
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                        .foregroundColor(.gray)

                    Button("Next") {
                        bool2 = true
                        userVM.triggerHapticFeedback() // Haptic feedback on tap
                    }
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .background(Color("ColorGreen"))
                    .cornerRadius(12)
                    .shadow(radius: 7, x: 0, y: 5)
                    .fullScreenCover(isPresented: $bool2) {
                        Onboarding_2()
                    }
                    .padding(.trailing, 50)
                }
                .padding(.top, userVM.scaledFont(baseSize: 70))

                Spacer()
            }
        }
    }
}

#Preview {
    Onboarding_1()
}
