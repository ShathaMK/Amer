//
//  NotificationView.swift
//  Amer
//
//  Created by Shaima Alhussain on 17/06/1446 AH.
//

import SwiftUI

struct NotificationView: View {
//    @StateObject var userVM = UserViewModel() // For dynamic scaling and haptics
    @EnvironmentObject var memberVM: MembersViewModel
    @EnvironmentObject var userVM : UserViewModel
    @State var inputText: String = "" // State variable to hold the text

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: userVM.scaledFont(baseSize: 20)) {
                    // Title
                    Text("Notification")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.leading, userVM.scaledFont(baseSize: 20))
                        .padding(.top, userVM.scaledFont(baseSize: 60))

                    Divider()
                        .frame(height: 2)
                        .overlay(Color(hex: 0xE8F6FF))
                        .frame(width: 330)
                        .padding(.top, -10)

                    // Notification Items
                    VStack(spacing: userVM.scaledFont(baseSize: 16)) {
                        NotificationItemView(
                            text: "Mom Monira wants Water",
                            time: "Now"
                        )
                        NotificationItemView(
                            text: "Mom Monira wants to eat",
                            time: "Now"
                        )
                        NotificationItemView(
                            text: "Mom Monira wants to \n shower",
                            time: "2 Min"
                        )
                        NotificationItemView(
                            text: "Mom Monira wants the \nwheelchair",
                            time: "5 Min"
                        )
                    }
                    .padding(.top, userVM.scaledFont(baseSize: 6))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: Onboarding_1()) {
                            HStack {
                                Image("Assistant_user")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: userVM.scaledFont(baseSize: 50), height: userVM.scaledFont(baseSize: 50))
                                Text("Hello Mohamed Saleh")
                                    .foregroundColor(Color("FontColor"))
                                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: Onboarding_1()) {
                            Image("AddButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: userVM.scaledFont(baseSize: 50), height: userVM.scaledFont(baseSize: 50))
                                .padding(.leading, userVM.scaledFont(baseSize: 80))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Notification Item View
struct NotificationItemView: View {
    @EnvironmentObject var userVM: UserViewModel // Access font size scaling and haptics
    var text: String
    var time: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(width: 325, height: userVM.scaledFont(baseSize: 80))
                .cornerRadius(20)
            HStack {
                // Bell Icon
                Image(systemName: "bell.fill")
                    .foregroundColor(Color("DarkBlue"))
                    .font(.system(size: userVM.scaledFont(baseSize: 25)))
                    .frame(width: userVM.scaledFont(baseSize: 22), height: userVM.scaledFont(baseSize: 25))
                    .padding(.leading, -150)

                Spacer()

                VStack(alignment: .leading) {
                    Text(text)
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                        .foregroundColor(Color("FontColor"))
                    Text(time)
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, userVM.scaledFont(baseSize: 20))
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            userVM.triggerHapticFeedback() // Haptic feedback on interaction
        }
    }
}

// MARK: - Preview
#Preview {
    NotificationView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(MembersViewModel())
}
