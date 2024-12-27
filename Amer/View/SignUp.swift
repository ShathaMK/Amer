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
    @State var roles: [String] = ["Assistant", "Reciver"]
    @State private var selectedRole: String = ""
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    @State private var isExpanded3: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
//    @State var selectedCountry: Country?
//    var countries: [Country]
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
                            Text(userVM.selectedCountry?.flag ?? userVM.defaultCountry.flag)
                                .font(.custom("Tajawal-Bold", size: 20))
                            Text(userVM.selectedCountry?.code ?? userVM.defaultCountry.code)
                                .font(.custom("Tajawal-Bold", size: 20))
                            
                        }
                        .font(.custom("Tajawal-Medium", size: 20))
                        .frame(width: 74, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    } // end button
                    
                    
                } // end vstack
                .navigationTitle("Country Selector")
                .sheet(isPresented:  $isExpanded2) {
                    countrySheet(
                        selectedCountry: $userVM.selectedCountry,
                        countries: userVM.countries
                    )
                    .searchable(text: $userVM.searchText, prompt: "Search countries")
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.visible)
                    
                }
                
                
                TextField("Enter Phone Number", text: $userVM.phoneNumber)
                    .font(.custom("Tajawal-Medium", size: 20))
                    .keyboardType( .numberPad)
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
        .onTapGesture {
            dismiss()
        }
//        // MARK: - Country Picker Sheet
//        .sheet(isPresented: $isExpanded2) {
//            NavigationStack {
//                VStack(spacing: 0) {
//                    ScrollView {
//                        VStack(spacing: 0) {
//                            List(countries, id: \.id) { country in
//                                Button(action: {
//                                    selectedCountry = country
//                                    dismiss()
//                                }) {
//                                    HStack {
//                                        Text(country.flag)
//                                            .font(.largeTitle)
//                                        Text(country.name)
//                                            .font(.headline)
//                                    }
//                                }
//                                
//                            }
//                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
//                            
//                            
//                            Spacer()
//                            
//                            
//                        }
//                        .searchable(text: $userVM.searchText, prompt: "Search countries")
//                        .navigationTitle("Countries")
//                        .navigationBarTitleDisplayMode(.inline)
//                        .presentationDetents([.fraction(0.3), .large])
//                        .presentationDragIndicator(.visible)
//                    }
//                }
//                
//            }
//            
//            
//        }// end sheet
        
        
        
    }
    
}



#Preview {
    
    SignUp()
//        .environmentObject(UserViewModel())
}
