//
//  EditProfileView.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var userVM = UserViewModel()
    
    @FocusState private var isKeyboardActive: Bool // To manage keyboard focus

    
    var body: some View {
        
        Form {
            Section(header: Text("Name")) {
                TextField("Enter Name", text: $userVM.userName)
                    .focused($isKeyboardActive)
                    .submitLabel(.done)
            }

            Section(header: Text("Phone Number")) {
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .keyboardType(.phonePad)
                    .focused($isKeyboardActive)
                    .submitLabel(.done)
            }

            // Save Button
            Button("Save") {
                userVM.saveProfile()
                isKeyboardActive = false // Dismiss keyboard
            }
            .buttonStyle(GreenButton())
            .padding()
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        
        
        
        
        
    }
}

#Preview {
    EditProfileView()
}
