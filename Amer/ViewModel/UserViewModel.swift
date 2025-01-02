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
    
    
    
    

    // MARK: - checkUserExists
    

    func checkUserExists(completion: @escaping (Bool, Error?) -> Void) {
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error)
                } else if let records = records, !records.isEmpty {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }

    
    
    // MARK: -  saving the user information in sign up process
    
    func saveUserToCloud(completion: @escaping (Result<Void, Error>) -> Void) {
            guard !name.isEmpty, !phoneNumber.isEmpty, !selectedRole.isEmpty else {
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "All fields are required."])))
                return
            }

            let record = CKRecord(recordType: "User")
            record["name"] = name as CKRecordValue
            record["phoneNumber"] = phoneNumber as CKRecordValue
            record["role"] = selectedRole as CKRecordValue

            let database = CKContainer.default().publicCloudDatabase
            database.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    
    
    
    
    
    //MARK: - saveProfile
    
//    func saveProfile(name: String, phoneNumber: String, role: String) {
//        self.name = name
//        self.phoneNumber = phoneNumber
//        self.selectedRole = role
//
//        let record = CKRecord(recordType: "User")
//        record["name"] = name as CKRecordValue
//        record["phoneNumber"] = phoneNumber as CKRecordValue
//        record["role"] = role as CKRecordValue
//
//        database.save(record) { [weak self] _, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = error.localizedDescription
//                    self?.isDataSaved = false
//                } else {
//                    self?.isDataSaved = true
//                }
//            }
//        }
//    }
    
    
    
    
    //MARK: - settings page
    @Published var fontSize: Double = 20.0 // Default font size
    @Published var isHapticsEnabled: Bool = true // Default haptics setting
    
    // Haptic Feedback Generator
    func triggerHapticFeedback() {
        guard isHapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Method to dynamically adjust font size based on the user's preference
        func scaledFont(baseSize: CGFloat) -> CGFloat {
            return baseSize * CGFloat(fontSize / 20.0) // Scales proportionally to the default size
        }
    
    
    // Save user settings (font size and haptics) to CloudKit
    func saveUserSettings(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        let query = CKQuery(recordType: "User", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching user record: \(error.localizedDescription)"
                    completion(false)
                }
                return
            }

            guard let record = records?.first else {
                DispatchQueue.main.async {
                    self.errorMessage = "User not found."
                    completion(false)
                }
                return
            }

            // Explicitly cast fontSize and isHapticsEnabled to CKRecordValue-compatible types
            record["fontSize"] = NSNumber(value: self.fontSize) as CKRecordValue
            record["isHapticsEnabled"] = NSNumber(value: self.isHapticsEnabled) as CKRecordValue

            self.database.save(record) { _, saveError in
                DispatchQueue.main.async {
                    if let saveError = saveError {
                        self.errorMessage = "Error saving user settings: \(saveError.localizedDescription)"
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    // MARK: - saving the edits of the information of the user
    
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

    
    
    
   
    
    
    // MARK: - fetch User Data
    

//    func fetchUserData(completion: @escaping (Bool) -> Void) {
//        let predicate = NSPredicate(value: true) // Adjust predicate as needed
//        let query = CKQuery(recordType: "User", predicate: predicate)
//
//        database.perform(query, inZoneWith: nil) { [weak self] records, error in
//            if let error = error {
//                print("Error fetching user data: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//
//            guard let records = records, let firstRecord = records.first else {
//                print("No user data found")
//                completion(false)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self?.name = firstRecord["name"] as? String ?? ""
//                self?.phoneNumber = firstRecord["phoneNumber"] as? String ?? ""
//                self?.selectedRole = firstRecord["role"] as? String ?? "Reciver"
//                completion(true)
//            }
//        }
//    }
    

    func fetchUserData(forPhoneNumber phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        let query = CKQuery(recordType: "User", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
                    print("Error fetching user data: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let record = records?.first else {
                    self?.errorMessage = "User not found."
                    print("No user data found")
                    completion(false)
                    return
                }

                self?.name = record["name"] as? String ?? "Unknown"
                self?.phoneNumber = record["phoneNumber"] as? String ?? "Unknown"
                self?.selectedRole = record["role"] as? String ?? "Reciver"
                self?.fontSize = record["fontSize"] as? Double ?? 20.0
                self?.isHapticsEnabled = record["isHapticsEnabled"] as? Bool ?? true

                print("User data fetched successfully")
                completion(true)
            }
        }
    }
    
    
    
    // MARK: - Verify Logged-In User and Fetch Data
    
        func fetchLoggedInUserData(completion: @escaping (Bool) -> Void) {
            guard !phoneNumber.isEmpty else {
                errorMessage = "Phone number is missing."
                completion(false)
                return
            }
            
            let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
            let query = CKQuery(recordType: "User", predicate: predicate)
            
            database.perform(query, inZoneWith: nil) { [weak self] records, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
                        completion(false)
                        return
                    }
                    
                    guard let record = records?.first else {
                        self?.errorMessage = "User not found."
                        completion(false)
                        return
                    }
                    
                    // Populate user details
                    self?.name = record["name"] as? String ?? ""
                    self?.phoneNumber = record["phoneNumber"] as? String ?? ""
                    self?.selectedRole = record["role"] as? String ?? "Reciver"
                    completion(true)
                }
            }
        }
    
    
    
   
    
    
    
    // MARK: - checking this later
    
    
//
//    func fetchUserData(completion: @escaping (Bool) -> Void) {
//        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
//        let query = CKQuery(recordType: "User", predicate: predicate)
//
//        database.perform(query, inZoneWith: nil) { [weak self] records, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error fetching user data: \(error.localizedDescription)")
//                    completion(false)
//                    return
//                }
//
//                guard let record = records?.first else {
//                    print("No user data found.")
//                    completion(false)
//                    return
//                }
//
//                self?.name = record["name"] as? String ?? ""
//                self?.selectedRole = record["role"] as? String ?? "Reciver"
//                completion(true)
//            }
//        }
//    }
//
//    
//    
//    // Fetch the logged-in user's buttons
//    func fetchUserButtons(completion: @escaping ([Buttons]) -> Void) {
//        let userReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: phoneNumber), action: .none)
//        let predicate = NSPredicate(format: "userId == %@", userReference)
//        let query = CKQuery(recordType: "UserButton", predicate: predicate)
//
//        database.perform(query, inZoneWith: nil) { [weak self] records, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error fetching user buttons: \(error.localizedDescription)")
//                    completion([])
//                    return
//                }
//
//                let buttons = records?.compactMap { record -> Buttons? in
//                    guard let buttonID = record["buttonId"] as? CKRecord.Reference else { return nil }
//                    return self?.fetchButtonDetails(recordID: buttonID.recordID)
//                } ?? []
//
//                completion(buttons)
//            }
//        }
//    }
//
//    // Helper to fetch button details
//    private func fetchButtonDetails(recordID: CKRecord.ID) -> Buttons? {
//        var fetchedButton: Buttons?
//        let semaphore = DispatchSemaphore(value: 0)
//
//        database.fetch(withRecordID: recordID) { record, error in
//            if let record = record {
//                fetchedButton = Buttons(
//                    label: record["label"] as? String ?? "",
//                    icon: record["icon"] as? String ?? "",
//                    color: Color(hex: UInt(record["color"] as? String ?? "0xFFFFFF") ?? 0xFFFFFF),
//                    isDisabled: record["isDisabled"] as? Int64 == 1
//                )
//            }
//            semaphore.signal()
//        }
//
//        semaphore.wait()
//        return fetchedButton
//    }
//    
//    
//    
//    
//    
//    
//        
//        // Fetch signed-in user's data
//        func fetchLoggedInUserData(completion: @escaping (Bool) -> Void) {
//            guard !phoneNumber.isEmpty else {
//                errorMessage = "Phone number is missing."
//                completion(false)
//                return
//            }
//            
//            let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
//            let query = CKQuery(recordType: "User", predicate: predicate)
//            
//            database.perform(query, inZoneWith: nil) { [weak self] records, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
//                        completion(false)
//                    }
//                    return
//                }
//                
//                guard let record = records?.first else {
//                    DispatchQueue.main.async {
//                        self?.errorMessage = "User not found."
//                        completion(false)
//                    }
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self?.name = record["name"] as? String ?? ""
//                    self?.role = record["role"] as? String ?? ""
//                    completion(true)
//                }
//            }
//        }
//        
//        // Fetch buttons associated with the user
//        func fetchUserButtons(completion: @escaping (Bool) -> Void) {
//            guard !phoneNumber.isEmpty else {
//                errorMessage = "Phone number is missing."
//                completion(false)
//                return
//            }
//            
//            let predicate = NSPredicate(format: "userId.phoneNumber == %@", phoneNumber)
//            let query = CKQuery(recordType: "UserButton", predicate: predicate)
//            
//            database.perform(query, inZoneWith: nil) { [weak self] records, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self?.errorMessage = "Error fetching buttons: \(error.localizedDescription)"
//                        completion(false)
//                    }
//                    return
//                }
//                
//                let fetchedButtons = records?.compactMap { record -> Buttons? in
//                    guard let buttonRecord = record["buttonId"] as? CKRecord.Reference else { return nil }
//                    
//                    // Create a Buttons object (assuming a model exists)
//                    return Buttons(
//                        id: buttonRecord.recordID,
//                        label: record["label"] as? String ?? "",
//                        icon: record["icon"] as? String ?? "",
//                        color: record["color"] as? String ?? "",
//                        isDisabled: (record["isDisabled"] as? Int64 ?? 0) == 1
//                    )
//                } ?? []
//                
//                DispatchQueue.main.async {
//                    self?.buttons = fetchedButtons
//                    completion(true)
//                }
//            }
//        }
    
    
    
    
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
    
    
   
    // MARK: - Dismiss Keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    
    
    
    
    // MARK: - this is the otp part
    
    
    
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
    
//    func sendVerificationCode() {
//        let phoneNumberWithCountryCode = selectedCountry!.code + phoneNumber // Adjust as needed
//        PhoneAuthProvider.provider()
//            .verifyPhoneNumber(phoneNumberWithCountryCode, uiDelegate: nil) { [weak self] verificationID, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self?.errorMessage = "Error: \(error.localizedDescription)"
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    self?.verificationID = verificationID
//                    self?.isVerificationSent = true
//                    self?.errorMessage = nil
//                }
//            }
//    }
    
    
    //Updated

    func sendVerificationCode(completion: @escaping (Bool) -> Void) {
        let phoneNumberWithCountryCode = selectedCountry!.code + phoneNumber // Adjust as needed
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumberWithCountryCode, uiDelegate: nil) { [weak self] verificationID, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "Error: \(error.localizedDescription)"
                        completion(false) // Signal failure
                        return
                    }
                    self?.verificationID = verificationID
                    self?.isVerificationSent = true
                    self?.errorMessage = nil
                    completion(true) // Signal success
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
