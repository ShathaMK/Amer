//
//  OTP_view.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI
import FirebaseAuth

struct OTP_view: View {
    
    
    @StateObject var userVM = UserViewModel()
    @FocusState private var focusedIndex: Int? // Tracks which text field is focused
    
//    var phoneNumber: String // Passed phone number from the previous screen
    @State private var otp: [String] = Array(repeating: "", count: 6) // 6-digit OTP
    @State private var isVerified: Bool = false // Tracks successful verification
    @State private var bool: Bool = false // Tracks successful verification
    

    @State private var isLoading: Bool = false // Tracks OTP submission
    @State private var isLoading2: Bool = false
    
    //this is for the  reCAPTCHA
    @State private var showSafari = false
    

//    var verificationID: String // Pass verification ID from the previous screen

    
    var body: some View {
        
        
        VStack {
            
            
            Text("Enter OTP")
                .font(Font.custom("Tajawal-Bold", size: 40))
                .multilineTextAlignment(.center)
                .padding(.top, 64)
            
            
            Spacer()
                .frame(height: 24)
            
            
            
            Image("sms")
                .resizable()
                .frame(width: 142.85, height: 169.31)
                .padding(.leading, 50)
            
            
            
            Spacer()
                .frame(height: 24)
            
            
            
            // Description
//            Text("OTP will be sent to this number \(phoneNumber)")
            Text("OTP will be sent to this number \(userVM.phoneNumber)")
                .font(Font.custom("Tajawal-Bold", size: 16))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            
            Spacer()
                .frame(height: 32)
            
            
            //MARK: - OTP Input Fields
            HStack(spacing: 10) {
                
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: Binding(
                        get: { otp[index] },
                        set: { value in
                            // Filter out non-numeric characters
                            let filtered = value.filter { $0.isNumber }
                            
                            if filtered.count <= 1 {
                                otp[index] = filtered
                            }
                            
                            // Move focus to next field if a digit is entered
                            if filtered.count == 1 && index < 5 {
                                focusedIndex = index + 1
                            }
                        }
                    ))
                    .font(Font.custom("Tajawal-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .shadow(radius: 7, x: 0, y: 5)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(focusedIndex == index ? Color("ColorBlue") : Color.gray.opacity(0.5), lineWidth: 2)
                    )
                    .focused($focusedIndex, equals: index)
                    .onTapGesture {
                        userVM.hideKeyboard()
                    }
                    
                }// end for each
            } // hstack end
            
            
            
            
            Spacer()
                .frame(height: 24)
            
            
            
            Button {
                
//                sendOTP()
            } label: {
                if isLoading2{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Send OTP")
                        .font(Font.custom("Tajawal-Medium", size: 20))
                        .foregroundColor(Color("DarkGreen"))
                }
            }.disabled(isLoading2 || userVM.timeRemaining < 60)

            
            
            //MARK: - Timer Text to show countdown
            if userVM.timeRemaining < 60 {
                Text("Resend OTP in \(userVM.timeRemaining) seconds")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            
            
            Spacer()
            
            
            //MARK: - this is for the  reCAPTCHA
            
            Button("Open Web Page") {
                showSafari = true
            }
            .sheet(isPresented: $showSafari) {
                UserViewModel.SafariView(url: URL(string: "https://www.example.com")!)
            }

            
            //MARK: - Submit Button
            Button(action: {
                verifyOTP()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Verify")
                        .font(Font.custom("Tajawal-Bold", size: 20))
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .buttonStyle(BlueButton())
            .shadow(radius: 7, x: 0, y: 5)
            .padding()
            // Navigation after successful OTP verification
            .fullScreenCover(isPresented: $isVerified) {
//                NextScreen() // Replace with your actual destination view
                ButtonListView()
            }
            .disabled(isLoading)
            .disabled(isLoading || otp.joined().count < 6)
            .disabled(otp.contains(where: { $0.isEmpty })) // Disable if any OTP field is empty
                  
            
            
            // Error Message
            if let errorMessage = userVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            

            
        } // end vstack
        .onAppear {
            focusedIndex = 0 // Focus the first OTP field
            userVM.startResendTimer() // Start the resend timer
        }
        .onDisappear {
            userVM.timer?.invalidate() // Invalidate the timer if the view disappears
        }
        
    } // end body view
    
    
    
   

    // MARK: - Verify OTP
//    private func verifyOTP() {
//        isLoading = true
//        let otpString = otp.joined() // Combine all OTP digits
//        
//        userVM.verifyOTP(otp: otpString) { success in
//            isLoading = false
//            if success {
//                print("User verified successfully.")
//                // Navigate to next view or handle success
//            } else {
//                print("OTP verification failed.")
//            }
//        }
//    }
        
    // MARK: - Verify OTP
//    private func verifyOTP() {
//        isLoading = true
//        let otpString = otp.joined() // Combine all OTP digits
//        
//        guard let verificationID = userVM.verificationID else {
//            userVM.errorMessage = "No verification ID found."
//            isLoading = false
//            return
//        }
//        
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID,
//            verificationCode: otpString
//        )
//        
//        Auth.auth().signIn(with: credential) { result, error in
//            isLoading = false
//            if let error = error {
//                userVM.errorMessage = "OTP verification failed: \(error.localizedDescription)"
//                print(userVM.errorMessage!)
//                return
//            }
//            
//            // Successfully signed in
//            print("User signed in successfully!")
//            isVerified = true // Navigate to the next view
//        }
//    }
    
    
    // MARK: - Verify OTP
    private func verifyOTP() {
        isLoading = true
        let otpString = otp.joined() // Combine all OTP digits

        // Ensure the verification ID is available
        guard let verificationID = userVM.verificationID else {
            userVM.errorMessage = "Verification ID not found. Please try again."
            isLoading = false
            return
        }

        // Create credential using the verification code and ID
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otpString
        )

        // Authenticate with Firebase
        Auth.auth().signIn(with: credential) { result, error in
            isLoading = false
            if let error = error {
                userVM.errorMessage = "OTP verification failed: \(error.localizedDescription)"
                print(userVM.errorMessage!)
                return
            }

            // Successfully signed in
            print("User signed in successfully!")
            isVerified.toggle()
        }
    }
    
    
}


struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTP_view()
    }
}

//#Preview {
////    OTP_view()
//    OTP_view(phoneNumber: "+966541013040")
//}
