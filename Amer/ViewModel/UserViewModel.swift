//
//  UserViewModel.swift
//  Amer
//
//  Created by Noori on 22/06/1446 AH.
//

import Foundation
import SwiftUI
import CloudKit

class UserViewModel: ObservableObject {
    @Published var name: String = ""
    @State var role: [String] = ["Assistant", "Reciver"]
    @Published var selectedRole: String = ""

    @Published var phoneNumber: String = ""
    @Published var searchText: String = ""
    @Published var countries: [Country] = []
    @Published var selectedCountry: Country? = nil
    let defaultCountry = Country(id: 0, name: "Saudi Arabia", flag: "🇸🇦", code: "+966")
    @Published var errorMessage: String? = nil
    @Published var isDataSaved: Bool = false

    private let database = CKContainer.default().publicCloudDatabase
    
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
    
    // MARK: - Save User to CloudKit
    func saveUser(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !name.isEmpty, !phoneNumber.isEmpty else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Name and Phone Number are required."])))
            return
        }

        let record = CKRecord(recordType: "User")
        record["name"] = name as CKRecordValue
        record["phoneNumber"] = (selectedCountry?.code ?? defaultCountry.code) + phoneNumber as CKRecordValue
        record["role"] = selectedRole as CKRecordValue // Add the role

        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isDataSaved = false
                    completion(.failure(error))
                } else {
                    self?.isDataSaved = true
                    self?.clearInputs()
                    completion(.success(()))
                }
            }
        }
    }

    // Clear Input Fields
    private func clearInputs() {
        name = ""
        phoneNumber = ""
        selectedCountry = defaultCountry
    }

    // MARK: - OTP Simulation
    @Published var otp: String = ""
    
    func sendOTP(to phoneNumber: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                completion(true) // Simulate successful OTP sending
            }
        }
    }
    
    func verifyOTP(_ otp: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                completion(otp == "123456") // Simulate valid OTP
            }
        }
    }
    
    // MARK: - Dismiss Keyboard
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
