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
import Combine

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
    
    
    

    
    // MARK: - Start Resend Timer
    
    @Published var timeRemaining: Int = 60
    private var timer: AnyCancellable?

    func startResendTimer() {
        timeRemaining = 60
        timer?.cancel() // Cancel any existing timer
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                }
            }
    }

    func resetTimer() {
        timer?.cancel()
        timeRemaining = 60
    }
    
    
    
    
    
    // MARK: - Send OTP
    
    
    @Published var verificationCode: String = ""
    
    @Published var verificationID: String?
    @Published var isVerificationSent: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    
    //MARK: - Function to send the OTP
    func sendVerificationCode() {
        let phoneNumberWithCountryCode = selectedCountry!.code + phoneNumber // Adjust as needed
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumberWithCountryCode, uiDelegate: nil) { [weak self] verificationID, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error: \(error.localizedDescription)"
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.verificationID = verificationID
                    self?.isVerificationSent = true
                    self?.errorMessage = nil
                }
            }
    }
    
    
    
    //MARK: -  Function to verify OTP
        func verifyCode(otp: [String], completion: @escaping (Bool) -> Void) {
            let otpString = otp.joined() // Combine the array into a single string
            
            guard let verificationID = self.verificationID else {
                self.errorMessage = "Verification ID is missing."
                completion(false)
                return
            }

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpString)

            Auth.auth().signIn(with: credential) { [weak self] _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error: \(error.localizedDescription)"
                    }
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    completion(true)
                }
            }
        }
    
    
    //MARK: - settings page
    
    @AppStorage("fontSize") var fontSize: Double = 16.0
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true
    
    // Save name and phone number persistently if needed
    func saveProfile() {
        // Add logic to persist the profile data (e.g., to a database or file)
        print("Profile saved: Name: \(userName), Phone: \(phoneNumber)")
    }
    
}



