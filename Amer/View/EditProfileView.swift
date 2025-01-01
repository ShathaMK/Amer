import SwiftUI
import CloudKit
import UIKit

struct EditProfileView: View {
    @StateObject private var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var bool = false
 
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    
    var EditUserInfo : User?
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("LightBlue")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: 96)
                        
                        //MARK: -  Name
                        
                        // Name input
                        Text("Name")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundColor(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        TextField("Enter Your Name", text: $userVM.name)
                            .font(.custom("Tajawal-Medium", size: 20))
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                userVM.hideKeyboard()
                            }
                        
                        Spacer().frame(height: 32)
                        
                        
                        //MARK: -  Phone number entry
                        
                        
                        Text("Phone Number")
                            .font(.custom("Tajawal-Bold", size: 20))
                            .foregroundColor(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        isExpanded2.toggle()
                                    }
                                }) {
                                    HStack {
                                        Text(userVM.selectedCountry?.flag ?? userVM.defaultCountry.flag)
                                            .font(.custom("Tajawal-Bold", size: 20))
                                            .foregroundColor(Color("FontColor"))
                                        Text(userVM.selectedCountry?.code ?? userVM.defaultCountry.code)
                                            .font(.custom("Tajawal-Bold", size: 20))
                                            .foregroundColor(Color("FontColor"))
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                }
                            }
                            .sheet(isPresented: $isExpanded2) {
                                countrySheet(
                                    selectedCountry: $userVM.selectedCountry,
                                    countries: userVM.countries
                                )
                                .presentationDetents([.fraction(0.7), .large])
                                .presentationDragIndicator(.visible)
                            }
                            
                            TextField("Enter Phone Number", text: $userVM.phoneNumber)
                                .font(.custom("Tajawal-Medium", size: 20))
                                .keyboardType(.numberPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                .onTapGesture {
                                    userVM.hideKeyboard()
                                }
                        }
                        .padding(.horizontal)
                        
                        
                        Spacer().frame(height: 32)
                        
                        
                        //MARK: -  Button to role
                        Text("Role")
                            .foregroundColor(Color("FontColor"))
                            .font(.custom("Tajawal-Bold", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        
                        // Button to show/hide the dropdown
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text(userVM.selectedRole.isEmpty ? "Select a role" : userVM.selectedRole) // Placeholder or selected role
                                    .foregroundColor(userVM.selectedRole.isEmpty ? .gray : .primary) // Gray for placeholder
                                    .font(.custom("Tajawal-Medium", size: 20))
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down") // Chevron toggle
                                    .foregroundStyle(Color("ColorBlue"))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.horizontal, 20)
                        }

                        // Dropdown list
                        if isExpanded {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(userVM.roles, id: \.self) { role in
                                    Button(action: {
                                        userVM.selectedRole = role // Update the selected role
                                        withAnimation {
                                            isExpanded = false // Close dropdown
                                        }
                                    }) {
                                        Text(role)
                                            .font(.custom("Tajawal-Medium", size: 20))
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(Color("FontColor"))
                                    }
                                    if role != userVM.roles.last { // Add a divider only between items
                                        Divider()
                                            .background(Color.gray.opacity(0.5))
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                            
                        
                        Spacer()
                            .frame(height: 100)
                        
                        // Save button
                        Button("Save") {
                            // Check if button details are not empty before saving
                            guard
                                !userVM.name.isEmpty,
                                !userVM.phoneNumber.isEmpty
                            else {
                                print("user details can't be empty")
                                return
                            }
                            
                            // Create a new button instance with the details
                            let newUserInfo = User(
                                id: EditUserInfo?.id ?? CKRecord.ID(), // Use CKRecord.ID for CloudKit compatibility
                                name: userVM.name,
                                phoneNumber: userVM.phoneNumber,
                                role: userVM.selectedRole
                     
                            )
                            
                            // Check if editing an existing button or adding a new one
                            if let EditUserInfo = EditUserInfo {
                                // Edit existing button
                                userVM.editUser(oldUserInfo: EditUserInfo, with: newUserInfo)
                         
                            }
                           // saveProfile()
                        }
                        .buttonStyle(GreenButton())
                        .padding()
                        
                        
                        
                        
                        // Cancel button
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                        .buttonStyle(cancelGreen())
                        .padding(.vertical, -30)
                        
                    } // end vstack
                    
                    
                } // end scroll view
                .frame(maxWidth: .infinity)
                .frame(height: 670)
                .background(Color.white)
                .cornerRadius(52)
                .padding(.top, 80)
                .onTapGesture {
                    userVM.hideKeyboard()
                }
                
                
                
                if userVM.selectedRole == "Assistant" {
                    Image("User_Assistant")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                } else if userVM.selectedRole == "Reciver" {
                    Image("User_Reciver")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                } else {
                    Image(systemName: "person.crop.circle") // Default image for unknown role
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 110, height: 110)
                        .padding(.bottom, 600)
                }
                
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color("FontColor"))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .foregroundColor(Color("FontColor"))
                        .font(.custom("Tajawal-Bold", size: 30))
                }
            }
        } // end Navigation view
    }

}

#Preview {
    EditProfileView()
}
