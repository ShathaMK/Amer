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

    // All countries loaded from JSON
    @Published var countries: [Country] = []
    
    // The currently selected country (optional)
    @Published var selectedCountry: Country? = nil
    
    @Published var searchText: String = ""
    
    init() {
            countries = loadCountries()
        }
        
        private func loadCountries() -> [Country] {
            // Load from your "countries.json" file in the bundle
            guard let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let decoded = try? JSONDecoder().decode([Country].self, from: data)
            else {
                return []
            }
            return decoded
        }
        
        // MARK: - Filtering Logic
        
        private func countryMatches(_ country: Country, tokens: [Substring]) -> Bool {
            // You might combine name, flag, and code to match
            let combinedString = (country.name + " " + country.flag + " " + country.code).lowercased()
            
            return tokens.allSatisfy { token in
                combinedString.contains(token)
            }
        }
        
        var filteredCountries: [Country] {
            if searchText.isEmpty {
                return countries
            } else {
                let tokens = searchText
                    .lowercased()
                    .split(separator: " ")
                
                return countries.filter { country in
                    countryMatches(country, tokens: tokens)
                }
            }
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
