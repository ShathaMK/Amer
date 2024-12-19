//
//  SettingsView.swift
//  Amer
//
//  Created by Shaima Alhussain on 16/06/1446 AH.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        @State var selectedUser: String = "Assistant" // Default user selection
        let users = ["Assistant", "receiver"] // List of users
        @State var isOn = true // State for the toggle
        VStack {
            // Picker to select the user
            Picker("Select User", selection: $selectedUser) {
                ForEach(users, id: \.self) { user in
                    Text(user).tag(user)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Conditional image display based on selected user
            if selectedUser == "Assistant" {
                Image("image1") // Replace with your actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else if selectedUser == "receiver" {
                Image("image2") // Replace with your actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Spacer()
        }
            Text("Mohammed Saleh Hamdan ")
            Text("+96650789644")
            Rectangle()
                .stroke(Color(.lightGray), lineWidth: 1)
                .frame(width: 290, height: 45)
                .background(Color(.lightBlue))
                .cornerRadius(8)
            Rectangle()
                .stroke(Color(.lightGray), lineWidth: 1)
                .frame(width: 290, height: 45)
                .background(Color(.lightBlue))
                .cornerRadius(8)
            Rectangle()
                .stroke(Color(.lightGray), lineWidth: 1)
                .frame(width: 290, height: 45)
                .foregroundColor(Color(.white))
                .cornerRadius(8)
//                .overlay(Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
//                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Label@*/Text("Vibration")
//                        .fontWeight(.bold)
//                        .font(.system(size: 15))
                .overlay(
                    HStack(spacing: 155) { // Control spacing between text and toggle
                        Text("Vibration")
                            .fontWeight(.bold)
                            .font(.system(size: 15))

                        Toggle("", isOn: $isOn) // Empty label for the toggle
                            .labelsHidden() // Hide the default label
                    }
                     
                        
                )
            ZStack {
                Rectangle()
                    .frame(width: 290, height: 45)
                    .foregroundColor(Color("DarkBlue"))
                    .cornerRadius(8)
              
                
                VStack {
                    HStack {
                        Text("Members")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(.trailing, 141.0)
                        
                        Image(systemName: "person.3.fill")
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding(5) // Add some space above the image
                    }
                }
            }
        }
    }

#Preview {
    ProfileView()
}
