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
    @Published var users: [User] = []

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
    
    func saveProfile(name: String, phoneNumber: String, role: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.selectedRole = role
        // Save to database or perform other actions
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
//
//    func loadButton(_ button: Buttons) {
//        guard let index = buttons.firstIndex(where: { $0.id == button.id }) else {
//            print("No matching button found with ID: \(button.id)")
//            return
//        }
//            print("Loaded button for editing: \(buttons[index])")
//            currentLabel = button.label
//            selectedIcon = button.icon
//            selectedColor = button.color
//            
//            
//        }
//
    
    func loadUserInfo(_ user:User){
        
        guard let index = users.firstIndex(where: {$0.id == user.id}) else {
           print("no matching user found with ID: \(user.id)")
            return
        }
        print("loaded user for editing: \(users[index])")
        name = user.name
        phoneNumber = user.phoneNumber
        selectedRole = user.role
    }
    
    
    func editUser(oldUserInfo: User , with newUserInfo: User){
        // fetch the CKrecord corresponding to the oldUserInfo
        let recordID = oldUserInfo.id
        database.fetch(withRecordID : recordID){ record , error in
            if let error = error {
                print ("Error fetching user to edit : \(error.localizedDescription)")
                return
            }
            
            guard let recordToUpdate = record else { return }
            
            // Update the record fields
            
            recordToUpdate["name"] = newUserInfo.name
            recordToUpdate["phoneNumber"] = newUserInfo.phoneNumber
            recordToUpdate["role"] = newUserInfo.role
            
            //Save the updated record to CloudKit
            self.database.save(recordToUpdate){ savedRecord , saveError in
                if let saveError = saveError
                {
                    print("Error saving updated user Info : \(saveError.localizedDescription)")
                    return
                    
                }
                
                // update local data model
                
                if let savedRecord = savedRecord {
                    let updatedUserInfo = User(record: savedRecord)
                    
                    // find the index of the old user info and update it
                    if let index = self.users.firstIndex(where: {$0.id == oldUserInfo.id}){
                        
                        self.users[index] = updatedUserInfo
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                            
                        }
                    }
                    
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
