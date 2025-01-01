//
//  UserViewModel.swift
//  Amer
//
//  Created by Noori on 22/06/1446 AH.
//

import Foundation
import SwiftUI
import CloudKit
import FirebaseAuth
import UIKit
import Combine

class UserViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var codePhone: String = ""
    @Published var phoneNumber: String = ""
    
    @State var roles: [String] = ["Assistant", "Reciver"]
    @Published var selectedRole: String = ""

    
    
    @Published var searchText: String = ""
    @Published var countries: [Country] = []
    @Published var selectedCountry: Country? = nil
    
    let defaultCountry = Country(id: 0, name: "Saudi Arabia", flag: "🇸🇦", code: "+966")
    
    @Published var errorMessage: String?
    @Published var isDataSaved: Bool = false
    @Published var users: [User] = []

    private let database = CKContainer.default().publicCloudDatabase
    
    init() {
        selectedCountry = Country(id: 0, name: "Saudi Arabia", flag: "🇸🇦", code: "+966")
        loadCountries()
    }
    
    //MARK: - Filtered Countries Based on Search
    
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
    
    
    private func updatePhoneNumber() {
        phoneNumber = (selectedCountry?.code ?? "") + codePhone
    }
    
    //MARK: - settings page
    @Published var fontSize: Double = 20.0 // Default font size
    @Published var isHapticsEnabled: Bool = true // Haptic feedback toggle

    
    // Function to update profile information
    func updateProfile(name: String, phone: String) {
        self.name = name
        self.phoneNumber = phone
    }
    
    
    
    
    //MARK: - saveProfile
    
//    func saveProfile(name: String, phoneNumber: String, role: String) {
//        self.name = name
//        self.phoneNumber = phoneNumber
//        self.selectedRole = role
//        // Save to database or perform other actions
//    }
    
    func saveProfile(name: String, phoneNumber: String, role: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.selectedRole = role

        let record = CKRecord(recordType: "User")
        record["name"] = name as CKRecordValue
        record["phoneNumber"] = phoneNumber as CKRecordValue
        record["role"] = role as CKRecordValue

        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isDataSaved = false
                } else {
                    self?.isDataSaved = true
                }
            }
        }
    }
    
    
    // MARK: - fetch User Data
    
    
    func fetchUserData(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true) // Adjust predicate as needed
        let query = CKQuery(recordType: "User", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let records = records, let firstRecord = records.first else {
                print("No user data found")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self?.name = firstRecord["name"] as? String ?? ""
                self?.phoneNumber = firstRecord["phoneNumber"] as? String ?? ""
                self?.selectedRole = firstRecord["role"] as? String ?? "Reciver"
                completion(true)
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Save User to CloudKit
//    func saveUser(completion: @escaping (Result<Void, Error>) -> Void) {
//        guard !name.isEmpty, !phoneNumber.isEmpty else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Name and Phone Number are required."])))
//            return
//        }
//
//        let record = CKRecord(recordType: "User")
//        record["name"] = name as CKRecordValue
//        record["phoneNumber"] = (selectedCountry?.code ?? defaultCountry.code) + phoneNumber as CKRecordValue
//        record["role"] = selectedRole as CKRecordValue // Add the role
//
//        database.save(record) { [weak self] _, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = error.localizedDescription
//                    self?.isDataSaved = false
//                    completion(.failure(error))
//                } else {
//                    self?.isDataSaved = true
//                    self?.clearInputs()
//                    completion(.success(()))
//                }
//            }
//        }
//    }
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
    
    // MARK: -
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
    
    
    // MARK: -
    
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

    
    // MARK: - Dismiss Keyboard
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
    
    
 
   
    
    
    
    
    
    
    
    
}
