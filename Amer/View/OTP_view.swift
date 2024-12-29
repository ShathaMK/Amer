//
//  OTP_view.swift
//  Amer
//
//  Created by Noori on 20/12/2024.
//

import SwiftUI

struct OTP_view: View {
    
    @StateObject var userVM = UserViewModel()
    @FocusState private var focusedIndex: Int? // Tracks which text field is focused
    
    var phoneNumber: String // Passed phone number from the previous screen
    @State private var otp: [String] = Array(repeating: "", count: 6) // 6-digit OTP
    @State private var isLoading: Bool = false // Tracks OTP submission
    @State private var isLoading2: Bool = false // Tracks OTP submission
    
    
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
            Text("OTP will be sent to this number \(phoneNumber)")
                .font(Font.custom("Tajawal-Bold", size: 16))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            
            Spacer()
                .frame(height: 32)
            
            // OTP Input Fields
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
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(focusedIndex == index ? Color("ColorBlue") : Color.gray.opacity(0.5), lineWidth: 2)
                    )
                    .focused($focusedIndex, equals: index)
                    
                }
            }
            
            
            // MARK: - OTP Input Fields
//            HStack(spacing: 10) {
//
//                ForEach(0..<6, id: \.self) { index in
//                    TextField("", text: Binding(
//                        get: { otp[index] },
//                        set: { value in
//                            // Filter out non-numeric characters
//                            let filtered = value.filter { $0.isNumber }
//
//                            if filtered.count <= 1 {
//                                otp[index] = filtered
//                            }
//
//                            // Move focus forward if a digit is entered
//                            if filtered.count == 1 && index < 5 {
//                                focusedIndex = index + 1
//                            }
//                            // Move focus back if the field is empty and it's not the first field
//                            else if filtered.isEmpty && index > 0 {
//                                focusedIndex = index - 1
//                            }
//                        }
//                    ))
//                    .font(Font.custom("Tajawal-Bold", size: 24))
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                    .frame(width: 50, height: 50)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(focusedIndex == index ? Color("ColorBlue") : Color.gray.opacity(0.5), lineWidth: 2)
//                    )
//                    .focused($focusedIndex, equals: index)
//
//                }
//            }
            
            
            
            
            Spacer()
                .frame(height: 24)
            
            
            Button {
                sendOTP()
            } label: {
                if isLoading2{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Send OTP")
                        .font(Font.custom("Tajawal-Medium", size: 20))
                        .foregroundColor(Color("DarkGreen"))
                }
            }.disabled(isLoading2)

            
            
//            // Resend OTP Button
//            Button("Resend OTP") {
//                sendOTP()
//            }
//            .font(Font.custom("Tajawal-Medium", size: 20))
//            .foregroundColor(Color("DarkGreen"))
//            .padding(.bottom, 16)
            
            
            
            Spacer()
            
            // Submit Button
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
            .padding()
            .disabled(isLoading)
            
            
            .onAppear {
                sendOTP() // Automatically send OTP when screen appears
                focusedIndex = 0 // Focus the first OTP field
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            
        } // end vstack
        
    } // end body view
    
    
    
    // MARK: - Send OTP
        private func sendOTP() {
            isLoading2 = true
            userVM.sendOTP(to: phoneNumber) { success in
                isLoading2 = false
                if success {
                    print("OTP sent to \(phoneNumber)")
                } else {
                    print("Failed to send OTP")
                }
            }
        }
        
        // MARK: - Verify OTP
        private func verifyOTP() {
            isLoading = true
            let otpString = otp.joined()
            userVM.verifyOTP(otpString) { success in
                isLoading = false
                if success {
                    print("OTP verified successfully")
                    // Proceed to next screen
                } else {
                    print("Invalid OTP")
                }
            }
        }
        
        // Hide Keyboard Helper
        private func hideKeyboard() {
            focusedIndex = nil
        }
    
    
    
    
}


struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTP_view(phoneNumber: "+966541013040")
    }
}

//#Preview {
////    OTP_view()
//    OTP_view(phoneNumber: "+966541013040")
//}
