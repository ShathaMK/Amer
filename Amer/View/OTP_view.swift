//
//  OTP_view.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import FirebaseAuth

struct OTP_view: View {
    @StateObject var userVM = UserViewModel() // For font scaling, haptics, and OTP management
//    @StateObject var buttonsVM = ButtonsViewModel()
    
    @EnvironmentObject var buttonsVM: ButtonsViewModel
//    @EnvironmentObject var userVM: UserViewModel
    
    @State private var otp: [String] = Array(repeating: "", count: 6) // 6-digit OTP
    @FocusState private var focusedIndex: Int? // Tracks which text field is focused
    @State private var isAuthenticated: Bool = false
    @State private var isLoading: Bool = false // Tracks OTP submission

    @Environment(\.presentationMode) var presentationMode // To dismiss the view

    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter OTP")
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 40)))

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 24))

                Image("sms")
                    .resizable()
                    .frame(width: 142.85, height: 169.31)
                    .padding(.leading, 50)

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 24))

                // Description
                Text("OTP will be sent to this number \(userVM.phoneNumber)")
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                
                
                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 32))

                
                
                //MARK: - OTP Input Fields
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: Binding(
                            get: { otp[index] },
                            set: { value in
                                let filtered = value.filter { $0.isNumber }
                                if filtered.count <= 1 {
                                    otp[index] = filtered
                                }
                                if filtered.count == 1 && index < 5 {
                                    focusedIndex = index + 1
                                }
                            }
                        ))
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 24)))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: userVM.scaledFont(baseSize: 50), height: userVM.scaledFont(baseSize: 50))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focusedIndex == index ? Color("ColorBlue") : Color.gray.opacity(0.5), lineWidth: 2)
                        )
                        .focused($focusedIndex, equals: index)
                        
                    }
                }
                .onTapGesture {
                    userVM.hideKeyboard()
                }

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 24))

                
                
                //MARK: - Resend Button
                Button {
                    userVM.triggerHapticFeedback()
                    if userVM.timeRemaining == 0 {
                        userVM.sendVerificationCode { success in
                            if success {
                                userVM.startResendTimer()
                            } else {
                                userVM.errorMessage = "Failed to send OTP. Please try again."
                            }
                        }
                    }
                } label: {
                    Text(userVM.timeRemaining > 0
                         ? "Resend OTP in \(userVM.timeRemaining)s"
                         : "Resend OTP")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                        .foregroundColor(userVM.timeRemaining > 0 ? .gray : Color("DarkGreen"))
                }
                .disabled(userVM.timeRemaining > 0)

                
                Spacer()
                
                

                if let errorMessage = userVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                

                //MARK: - Submit Button
                Button(action: {
                    userVM.triggerHapticFeedback()
                    isLoading = true
                    userVM.verifyCode(otp: otp) { success in
                        isLoading = false
                        if success {
                            isAuthenticated = true
                        }
                    }
                    
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Verify")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("DarkBlue"))
                            .cornerRadius(8)
                    }
                }
                .buttonStyle(BlueButton())
                .shadow(radius: 7, x: 0, y: 5)
                .padding()
                .fullScreenCover(isPresented: $isAuthenticated) {
                    RemoteView()
                        
                }
                .disabled(isLoading || otp.joined().count < 6)
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
                    Text("OTP Verification")
                        .foregroundColor(Color("FontColor"))
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                }
            }
        }
        .onAppear {
            focusedIndex = 0
            userVM.startResendTimer()
        }
        .onTapGesture {
            userVM.hideKeyboard()
        }
        
        
        
    }
}

//struct OTPView_Previews: PreviewProvider {
//    static var previews: some View {
//        OTP_view()
//            .environmentObject(UserViewModel()) 
//    }
//}

#Preview {
    OTP_view()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
}
