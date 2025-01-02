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
    @StateObject var buttonsVM = ButtonsViewModel()
    
    
    @State private var otp: [String] = Array(repeating: "", count: 6) // 6-digit OTP
    @FocusState private var focusedIndex: Int? // Tracks which text field is focused
    @State private var isAuthenticated: Bool = false
    
    @State private var isVerified: Bool = false // Tracks successful verification

    @State private var isLoading: Bool = false // Tracks OTP submission
    @State private var isLoading2: Bool = false



    
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
            
            
            //MARK: - Resend Button
            Button {
                
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
                if isLoading2{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text(userVM.timeRemaining > 0
                         ? "Resend OTP in \(userVM.timeRemaining)s"
                         : "Resend OTP")
                        .font(Font.custom("Tajawal-Bold", size: 20))
                        .foregroundColor(userVM.timeRemaining > 0 ? .gray : Color("DarkGreen"))
                }
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
                userVM.verifyCode(otp: otp) { success in
                    if success {
                        isAuthenticated.toggle()
                    }
                }
                
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
            .fullScreenCover(isPresented: $isAuthenticated) {
//                EditProfileView()
                RemoteView()
                    .environmentObject(buttonsVM)
                    .environmentObject(userVM)
            }
            .disabled(isLoading || otp.joined().count < 6)
            .disabled(otp.contains(where: { $0.isEmpty })) // Disable if any OTP field is empty
            
            
            
            
        }
        .onAppear(){
            focusedIndex = 0
            userVM.startResendTimer()
        }
        
        
        
    }// end body view
    
    

    // MARK: - Verify OTP

    
    
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
