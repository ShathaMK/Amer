import SwiftUI
import CloudKit
import UIKit

struct EditProfileView: View {
//    @EnvironmentObject var userVM = UserViewModel
    @StateObject var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var bool = false
 
    @State private var isExpanded: Bool = false // dropdown bool
    @State private var isExpanded2: Bool = false // sheet bool
    
    var EditUserInfo: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("LightBlue")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: 96)
                        
                        // MARK: - Name
                        Text("Name")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundColor(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        TextField("Enter Your Name", text: $userVM.name)
                            .font(.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                userVM.hideKeyboard()
                                userVM.triggerHapticFeedback() // Haptic feedback
                            }
                        
                        Spacer().frame(height: 32)
                        
                        // MARK: - Phone Number
                        Text("Phone Number")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundColor(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        isExpanded2.toggle()
                                    }
                                    userVM.triggerHapticFeedback() // Haptic feedback
                                }) {
                                    HStack {
                                        Text(userVM.selectedCountry?.flag ?? userVM.defaultCountry.flag)
                                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                            .foregroundColor(Color("FontColor"))
                                        Text(userVM.selectedCountry?.code ?? userVM.defaultCountry.code)
                                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
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
                                .font(.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                                .keyboardType(.numberPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                .onTapGesture {
                                    userVM.hideKeyboard()
                                    userVM.triggerHapticFeedback() // Haptic feedback
                                }
                        }
                        .padding(.horizontal)
                        
                        Spacer().frame(height: 32)
                        
                        // MARK: - Role Selection
                        Text("Role")
                            .foregroundColor(Color("FontColor"))
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                            userVM.triggerHapticFeedback() // Haptic feedback
                        }) {
                            HStack {
                                Text(userVM.selectedRole.isEmpty ? "Select a role" : userVM.selectedRole)
                                    .foregroundColor(userVM.selectedRole.isEmpty ? .gray : .primary)
                                    .font(.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundStyle(Color("ColorBlue"))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.horizontal, 20)
                        }

                        if isExpanded {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(userVM.roles, id: \.self) { role in
                                    Button(action: {
                                        userVM.selectedRole = role
                                        withAnimation {
                                            isExpanded = false
                                        }
                                        userVM.triggerHapticFeedback() // Haptic feedback
                                    }) {
                                        Text(role)
                                            .font(.custom("Tajawal-Medium", size: userVM.scaledFont(baseSize: 20)))
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(Color("FontColor"))
                                    }
                                    if role != userVM.roles.last {
                                        Divider()
                                            .background(Color.gray.opacity(0.5))
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                            
                        Spacer().frame(height: 100)
                        
                        // Save Button
                        Button("Save") {
                            guard
                                !userVM.name.isEmpty,
                                !userVM.phoneNumber.isEmpty
                            else {
                                print("User details can't be empty")
                                return
                            }
                            
                            let newUserInfo = User(
                                id: EditUserInfo?.id ?? CKRecord.ID(),
                                name: userVM.name,
                                phoneNumber: userVM.phoneNumber,
                                role: userVM.selectedRole
                            )
                            
                            if let EditUserInfo = EditUserInfo {
                                userVM.editUser(oldUserInfo: EditUserInfo, with: newUserInfo)
                            }
                        }
                        .buttonStyle(GreenButton())
                        .padding()
                        
                        // Cancel Button
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                            userVM.triggerHapticFeedback() // Haptic feedback
                        }
                        .buttonStyle(cancelGreen())
                        .padding(.vertical, -30)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 670)
                .background(Color("VLightBlue"))
                .cornerRadius(52)
                .padding(.top, 80)
            }
            .onTapGesture {
                userVM.hideKeyboard()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        userVM.triggerHapticFeedback() // Haptic feedback
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
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
