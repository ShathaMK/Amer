import SwiftUI
import CloudKit
import UIKit

struct EditProfileView: View {
    @StateObject private var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var bool = false
    
    // Dropdown data
    @State var roles: [String] = ["Assistant", "Receiver"]
    @State private var selectedRole: String = ""
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    var EditUserInfo : User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("GrayBlue")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: 96)
                        
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
                        
                        // Phone number entry
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
                        .padding(.horizontal, 20)
                        
                        Spacer().frame(height: 32)
                        
                        // Role dropdown
                        VStack {
                            Text("Role")
                                .foregroundColor(Color("FontColor"))
                                .font(.custom("Tajawal-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text(selectedRole.isEmpty ? "Select a role" : selectedRole)
                                        .foregroundColor(selectedRole.isEmpty ? .gray : .primary)
                                        .font(.custom("Tajawal-Medium", size: 20))
                                    Spacer()
                                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundStyle(Color("ColorBlue"))
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                .padding(.horizontal, 20)
                            }
                            
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
                            .frame(height: 22)
                        
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
                        .buttonStyle(cancelGreen())
                        .padding(.bottom, 30)
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 670)
                .background(Color.white)
                .cornerRadius(52)
                .padding(.top, 80)
                .onTapGesture {
                    userVM.hideKeyboard()
                }
                Image("profile_logo")
                    .padding(.bottom,600)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color("DarkBlue"))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .foregroundColor(Color("FontColor"))
                        .font(.custom("Tajawal-Bold", size: 30))
                }
            }
        }
    }
    
//    // Function to save the profile
//    private func saveProfile() {
//        // Validate inputs
//        guard !userVM.name.isEmpty, !userVM.phoneNumber.isEmpty, !selectedRole.isEmpty else {
//            print("Please fill all fields.")
//            return
//        }
//        
//        // Save to ViewModel or send to backend
//        $userVM.saveProfile(name: userVM.name, phoneNumber: userVM.phoneNumber, role: userVM.selectedRole)
//        print("Profile saved successfully!")
//        
//        // Dismiss the view
//        presentationMode.wrappedValue.dismiss()
//    }
}

#Preview {
    EditProfileView()
}
