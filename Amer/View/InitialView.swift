//
//  InitialView.swift
//  Amer
//
//  Created by Noori on 31/12/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct InitialView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        
          
        VStack{
            if userLoggedIn{
                
                ButtonListView()
                    .environmentObject(ButtonsViewModel())
                    .environmentObject(UserViewModel())
                    .environmentObject(MembersViewModel())
            } else {
                
                LoginSignupView()
                    .environmentObject(ButtonsViewModel())
                    .environmentObject(UserViewModel())
                    .environmentObject(MembersViewModel())
            }
        }
        .onAppear{
            
            Auth.auth().addStateDidChangeListener{auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else{
                    userLoggedIn = false
                }
            }
            
        }
        
        
    }
}

#Preview {
    InitialView()
}
