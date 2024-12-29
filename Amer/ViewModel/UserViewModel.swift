//
//  UserViewModel.swift
//  Amer
//
//  Created by Noori on 22/06/1446 AH.
//


import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var phoneNumber: String = ""

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
    
    // MARK: - here i will do the OTP proprty
    
    @Published var otp: String = ""
        
        // Simulate sending OTP
        func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
            // Simulate an API call to send OTP
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                DispatchQueue.main.async {
                    completion(true) // Assume OTP sent successfully
                }
            }
        }
        
        // Simulate verifying OTP
        func verifyOTP(_ otp: String, completion: @escaping (Bool) -> Void) {
            // Simulate an API call to verify OTP
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                DispatchQueue.main.async {
                    completion(otp == "123456") // Simulate valid OTP
                }
            }
        }
    
    
    
    
    
    // MARK: - to dissmiss the keyboard
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
    
    
}






//// MARK: - here i will do the OTP proprty
//@Published var otp: [String] = ["", "", "", ""] // For 6-digit OTP
//@Published var isValidOTP: Bool = false
//
//// Validate the OTP
//func validateOTP() {
//   let otpString = otp.joined()
//   if otpString.count == 4 {
//       
//       
//       // Example validation logic
//       isValidOTP = otpString == "1234" // Replace with your actual validation logic
//       
//       
//   } else {
//       isValidOTP = false
//   }
//}
//
//// Clear the OTP
//func clearOTP() {
//   otp = ["", "", "", ""]
//}
