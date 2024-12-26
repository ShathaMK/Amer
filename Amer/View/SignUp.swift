//
//  SignIn.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import CloudKit

struct SignUp: View {
    
    @StateObject private var userVM = UserViewModel()
    
    // Bound text fields to these @State vars
//    @State private var userName: String = ""
//    @State private var phoneNumber: String = ""
    
    @State private var bool = false
    
    // Dropdown data
    @State private var roles: [String] = ["Assistant", "Reciver"]
    @State private var selectedRole: String = ""
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    
    
    var body: some View {
        
    
        VStack() {
            
           
            Text("Name")
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
            
                // Allow the user to enter their name
            TextField("Enter Your Name", text: $userVM.userName)
                    .font(.custom("Tajawal-Medium", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    .padding(.horizontal, 20)
                    
                
            
            Spacer().frame(height: 32)
            
            // MARK: - phone number
            
            Text("Phone Number")
                .font(.custom("Tajawal-Bold", size: 20))
                .foregroundColor(Color("FontColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack{
                
               VStack(alignment: .leading, spacing: 0) {
                   
                   // The button to toggle dropdown
                   Button(action: {
                       withAnimation {
                           isExpanded2.toggle()
                       }
                   }) {
                       HStack {
                           // Show the selected country or a placeholder if nil
                          if let selected = userVM.selectedCountry {
                              Text("\(selected.flag) \(selected.code)")
                                  .foregroundColor(.primary)
                          } else {
                              Text("country")
                                  .foregroundColor(.gray)
                          }

                       }
                       .font(.custom("Tajawal-Medium", size: 20))
                       .frame(width: 70, alignment: .leading)
                       .padding()
                       .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                   } // end button
                   
                   
               } // end vstack
               
               
                
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .font(.custom("Tajawal-Medium", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    
            } // end hstack
            .padding(.horizontal, 20)
            
            
            
            Spacer().frame(height: 32)
            
            
            // MARK: - the drop down for the role
            
                
                VStack {
                    
                    Text("Role")
                        .foregroundColor(Color("FontColor"))
                        .font(.custom("Tajawal-Bold", size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    
                    // Button to show/hide the list
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedRole.isEmpty ? "Select a role" : selectedRole) // Show placeholder if no role is selected
                                .foregroundColor(selectedRole.isEmpty ? .gray : .primary) // Placeholder color
                                .font(.custom("Tajawal-Medium", size: 20))
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundStyle(Color("ColorBlue"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .padding(.horizontal, 20)
                    }
                    
                    // The dropdown list
                    if isExpanded {
                        ForEach(roles, id: \.self) { role in
                            Button(action: {
                                selectedRole = role
                                withAnimation {
                                    isExpanded = false
                                }
                            }) {
                                Text(role)
                                    .font(.custom("Tajawal-Medium", size: 20))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(Color("FontColor"))
                            }
                            .padding(.horizontal, 20)
                            Divider()
                                .background(Color.gray.opacity(0.5))
                                .padding(.horizontal, 20)
                        }
                    }
                }
                
                
                        
            
            Spacer()
            
            
            Button("Send"){
                
            }
            .buttonStyle(GreenButton())
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $bool) {
                OTP_view()
            }
            
            
        } // end vstack
        // MARK: - Country Picker Sheet
        .sheet(isPresented: $isExpanded2) {
            NavigationStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Use the *filteredCountries* to allow search
                            ForEach(userVM.filteredCountries, id: \.id) { country in
                                Button {
                                    userVM.selectedCountry = country
                                    withAnimation {
                                        isExpanded2 = false
                                    }
                                } label: {
                                    // Show name, flag, or code
                                    Text("\(country.flag) \(country.name) (\(country.code))")
                                        .font(.custom("Tajawal-Medium", size: 20))
                                        .foregroundStyle(Color("FontColor"))
                                        .padding(.vertical, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                            }
                        }
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .searchable(text: $userVM.searchText, prompt: "Search countries")
                .navigationTitle("Countries")
                .navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.fraction(0.3), .large])
                .presentationDragIndicator(.visible)
            }
        }
        
        
        
    }
}

#Preview {
    SignUp()
    
}
