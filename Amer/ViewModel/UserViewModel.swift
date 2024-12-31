//
//  UserViewModel.swift
//  Amer
//
//  Created by Noori on 22/06/1446 AH.
//


import Foundation
import SwiftUI
import SafariServices
import FirebaseAuth
import UIKit

class UserViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var phoneNumber: String = ""
    @Published var roles: [String] = ["Assistant", "Reciver"]
    
    @Published var selectedRole: String = ""

    @Published var searchText: String = ""
    
    @Published var countries: [Country] = []
    @Published var selectedCountry: Country? = nil
    let defaultCountry = Country(id: 0, name: "Saudi Arabia", flag: "🇸🇦", code: "+966")
    

    
    init() {
        selectedCountry = Country(id: 0, name: "Saudi Arabia", flag: "🇸🇦", code: "+966")
        loadCountries()
    }
    
    // Filtered Countries Based on Search
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { country in
                country.name.lowercased().contains(searchText.lowercased()) ||
                country.flag.contains(searchText) ||
                country.code.contains(searchText)
            }
        }
    }
    
    
    private func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let loadedCountries = try JSONDecoder().decode([Country].self, from: data)
            DispatchQueue.main.async {
                self.countries = loadedCountries
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    
    
    
    // MARK: - hide keyboard func
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    

    // MARK: -  sending the reCAPTCHA
    
    struct SafariView: UIViewControllerRepresentable {
        let url: URL

        func makeUIViewController(context: Context) -> SFSafariViewController {
            return SFSafariViewController(url: url)
        }

        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
    }
    
    
    
    // MARK: - Start Resend Timer
    
    @Published var timeRemaining = 60 // Time remaining for resend button
    @Published var timer: Timer? = nil // Timer for countdown
    
    func startResendTimer() {
        timeRemaining = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }

    // MARK: - Reset Resend Timer
     func resetResendTimer() {
        timer?.invalidate() // Invalidate any existing timer
        startResendTimer() // Start a new timer
    }
    
    
    
    
    
    // MARK: - Authentacation
    
    
    @Published var verificationID: String? = nil
    @Published var isVerified: Bool = false
    @Published var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
    @Published var errorMessage: String? = nil
    
    @Published private var isVerificationSent: Bool = false
    
    // MARK: - Send OTP
    
    
//    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
//            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Error sending OTP: \(error.localizedDescription)"
//                        print(self.errorMessage!)
//                    }
//                    
//                    completion(false)
//                    return
//                }
//                
//
//                DispatchQueue.main.async {
//                    self.verificationID = verificationID
//                    self.errorMessage = nil
//                }
//                completion(true)
//            }
//        }
    
    
//    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
//        print("Sending OTP to: \(phoneNumber)") // Debug the number
//
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error sending OTP: \(error.localizedDescription)"
//                    print(self.errorMessage!)
//                }
//                completion(false)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.verificationID = verificationID
//                self.errorMessage = nil
//                print("OTP sent successfully. Verification ID: \(verificationID ?? "nil")")
//            }
//            completion(true)
//        }
//    }
    
    
//    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
//        print("Sending OTP to: \(phoneNumber)") // Debugging
//
//
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error sending OTP: \(error.localizedDescription)"
//                    print("Firebase error: \(error.localizedDescription)")
//                }
//                completion(false)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.verificationID = verificationID
//                self.errorMessage = nil
//                print("OTP sent successfully. Verification ID: \(verificationID ?? "nil")")
//            }
//            completion(true)
//        }
//    }
    
    
    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error sending OTP: \(error.localizedDescription)"
                        print(self.errorMessage ?? "Unknown error")
                    }
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    self.verificationID = verificationID
                    self.isVerificationSent = true
                    self.errorMessage = nil
                }
                completion(true)
            }
        }
    
        
        // MARK: - Verify OTP
    
        func verifyOTP(otp: String, completion: @escaping (Bool) -> Void) {
            guard let verificationID = verificationID else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid verification process."
                }
                completion(false)
                return
            }

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Verification failed: \(error.localizedDescription)"
                    }
                    completion(false)
                    return
                }

                DispatchQueue.main.async {
                    self.errorMessage = nil
                }
                completion(true)
            }
        }
        
        // MARK: - Sign Out
    
        func signOut() {
            do {
                try Auth.auth().signOut()
                self.isUserLoggedIn = false
            } catch {
                self.errorMessage = "Error signing out: \(error.localizedDescription)"
            }
        }
    
    
    
    //MARK: - Handle Authentication State:
    
//    func monitorAuthState() {
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if let user = user {
//                print("User is signed in: \(user.uid)")
//            } else {
//                print("User is signed out.")
//            }
//        }
//    }
    
    
}



