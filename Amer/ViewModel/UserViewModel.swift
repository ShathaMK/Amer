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
    @Published var phoneNumber: String = ""
    
    @State var roles: [String] = ["Assistant", "Reciver"]
    @Published var selectedRole: String = ""
    @Published var assistantRecordID: CKRecord.ID? // This should hold the assistant's record ID

    
    
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
        startKeyboardObserver()
    }
    
    
    
    
    
    // =======================================================
    // MARK: - country json file decoding
    // =======================================================
    
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
    
    
    
    // =======================================================
    // MARK: - END country json file decoding
    // =======================================================
    

    
    
    
    
    
    
    
    
    // =======================================================
    // MARK: - OTP process
    // =======================================================
    
    
    // MARK: - Send OTP
    
    
    @Published var verificationCode: String = ""
    @Published var verificationID: String?
    @Published var isVerificationSent: Bool = false
    @Published var isAuthenticated: Bool = false
    
    
    
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
    
    
    
    // =======================================================
    // MARK: - END OTP process
    // =======================================================
    
    
    
    
    
    
    
    // =======================================================
    // MARK: - sign up process evaluation
    // =======================================================
    
    // MARK: - checkUserExists
    
    func checkUserExists(completion: @escaping (Bool, Error?) -> Void) {
        let phoneNumberCode = selectedCountry!.code + phoneNumber
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumberCode)
        let query = CKQuery(recordType: "User", predicate: predicate)

        print(phoneNumberCode)

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
    
    
//    func saveUserToCloudKit(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let record = CKRecord(recordType: "User")
//        record["userId"] = userId
//        record["name"] = self.name
//        record["phoneNumber"] = self.phoneNumber
//        record["role"] = self.selectedRole
//
//        let database = CKContainer.default().publicCloudDatabase
//        database.save(record) { _, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
    
    func saveUserToCloud( completion: @escaping (Result<Void, Error>) -> Void) {
        let phoneNumberCode = selectedCountry!.code + phoneNumber
//        let id = UUID().uuidString
        
            guard !name.isEmpty, !phoneNumber.isEmpty, !selectedRole.isEmpty else {
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "All fields are required."])))
                return
            }

            let record = CKRecord(recordType: "User")
//            record["id"] = id as CKRecordValue
            record["name"] = name as CKRecordValue
            record["phoneNumber"] = phoneNumberCode as CKRecordValue
            record["role"] = selectedRole as CKRecordValue
        
            // Check if there's a device token available (from Firebase/APNs)
            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                record["deviceToken"] = deviceToken as CKRecordValue
                print("Token \(deviceToken)")
            }

            let database = CKContainer.default().publicCloudDatabase
            database.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        print("User record saved")
                        completion(.success(()))
                    }
                }
            }
        }
    
    
    
    // =======================================================
    // MARK: - END sign up process evaluation
    // =======================================================
    
    
    
    func saveDeviceTokenToCloudKit(deviceToken: String) {
        let database = CKContainer.default().publicCloudDatabase
        let phoneNumberCode = selectedCountry?.code ?? defaultCountry.code + phoneNumber

        // Query the user by phone number
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumberCode)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let records = records, let userRecord = records.first {
                    userRecord["deviceToken"] = deviceToken
                    
                    // Save the updated record
                    database.save(userRecord) { _, saveError in
                        if let saveError = saveError {
                            print("Error saving device token: \(saveError)")
                        } else {
                            print("Device token successfully saved!")
                        }
                    }
                } else if let error = error {
                    print("Error fetching user record: \(error)")
                }
            }
        }
    }
    
    
    
    
    
    func fetchUserData(forPhoneNumber phone: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "phoneNumber == %@", phone)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
                    completion(false)
                    return
                }
                
                guard let record = records?.first else {
                    self?.errorMessage = "No user found for phone number: \(phone)"
                    completion(false)
                    return
                }
                
                // Set local fields
                self?.name = record["name"] as? String ?? ""
                self?.phoneNumber = record["phoneNumber"] as? String ?? ""
                self?.selectedRole = record["role"] as? String ?? ""
                
                print(self!.name )
                print(self!.phoneNumber )
                print(self!.selectedRole )
                
                completion(true)
            }
        }
    }
    
    
    
    // =======================================================
    // MARK: - User data mining
    // =======================================================
    
    private func constructFullPhoneNumber(_ phoneNumber: String) -> String {
        return (selectedCountry?.code ?? defaultCountry.code) + phoneNumber
    }
   
    
    
    
    
    // MARK: - Fetch User Data
    
//     func updatePhoneNumber() {
//         var nonsence = selectedCountry!.code + phoneNumber
//         print(nonsence + "this is what was bothring me ")
//    }
//
//
//
//    func fetchUserData(forPhoneNumber phoneNumber: String, completion: @escaping (Bool) -> Void) {
//        let phoneNumberCode = selectedCountry!.code + phoneNumber
//        print("Fetching user data for exact phone number: \(phoneNumber) or \(phoneNumberCode)")
//
//        fetchUserRecord(phoneNumber: phoneNumberCode) { [weak self] record, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
//                    print("Error fetching user data: \(error.localizedDescription)")
//                    completion(false)
//                    return
//                }
//
//                guard let record = record else {
//                    self?.errorMessage = "User not found."
//                    print("No user data found for phone number: \(phoneNumber) or \(phoneNumberCode) ")
//                    completion(false)
//                    return
//                }
//
//                // Populate ViewModel with fetched data
//                self?.populateUserData(from: record)
//                print("User data fetched successfully for \(phoneNumber)")
//                completion(true)
//            }
//        }
//    }
//
//    // MARK: - Verify Logged-In User and Fetch Data
//    func fetchLoggedInUserData(completion: @escaping (Bool) -> Void) {
//        // Combine country code and phone number
//        let phoneNumberCode = selectedCountry!.code + phoneNumber
//
//        guard !phoneNumber.isEmpty else {
//            errorMessage = "Phone number is missing."
//            print("Error: Phone number is missing.")
//            completion(false)
//            return
//        }
//
//
//        print("Fetching user data for phone number: \(phoneNumberCode)")
//
//        fetchUserRecord(phoneNumber: phoneNumberCode) { [weak self] record, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
//                    print("Error fetching user data: \(error.localizedDescription)")
//                    completion(false)
//                    return
//                }
//
//                guard let record = record else {
//                    self?.errorMessage = "User not found."
//                    print("No user data found for phone number: \(phoneNumberCode)")
//                    completion(false)
//                    return
//                }
//
//                // Populate ViewModel with fetched data
//                self?.populateUserData(from: record)
//                print("User data fetched successfully for \(phoneNumberCode)")
//                completion(true)
//            }
//        }
//    }
//
//    // MARK: - Helper Method to Fetch User Record
//    private func fetchUserRecord(phoneNumber: String, completion: @escaping (CKRecord?, Error?) -> Void) {
//        let phoneNumberCode = selectedCountry!.code + phoneNumber
//        // Create a predicate to match the exact phone number
//        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumberCode)
//        let query = CKQuery(recordType: "User", predicate: predicate)
//
//        database.perform(query, inZoneWith: nil) { records, error in
//            completion(records?.first, error)
//        }
//    }
//
//    // MARK: - Helper Method to Populate ViewModel with User Data
//    private func populateUserData(from record: CKRecord) {
//        self.name = record["name"] as? String ?? "Unknown"
//        self.phoneNumber = record["phoneNumber"] as? String ?? "Unknown"
//        self.selectedRole = record["role"] as? String ?? " "
//        self.fontSize = record["fontSize"] as? Double ?? 20.0
//        self.isHapticsEnabled = record["isHapticsEnabled"] as? Bool ?? true
//
//        print("User data fetched successfully")
//        print("Name: \(name), Phone: \(phoneNumber), Role: \(selectedRole)")
//    }
    
    
    
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
    
    
    
    
    // =======================================================
    // MARK: - settings page
    // =======================================================
    
    @Published var fontSize: Double = 20.0 // Default font size
    @Published var isHapticsEnabled: Bool = true // Default haptics setting
    
    // Haptic Feedback Generator
    func triggerHapticFeedback() {
        guard isHapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Method to dynamically adjust font size based on the user's preference
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
    
    

    
    
    // =======================================================
    // MARK: -  END settings page
    // =======================================================
    
    
   

    
    // =======================================================
    // MARK: -  Keyboard edits
    // =======================================================
   
    // MARK: - Dismiss Keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // to help not shiftin elements when the keyboard shows
    
    @Published var keyboardHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel() // Cancel the subscription when UserViewModel is deinitialized
    }
    
    // MARK: - Start Keyboard Observer
    private func startKeyboardObserver() {
        cancellable = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification -> CGFloat? in
                if let frameEnd = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    return frameEnd.height
                }
                return 0
            }
            .assign(to: \.keyboardHeight, on: self)
    }
    
    
    // =======================================================
    // MARK: - END Keyboard edits
    // =======================================================
    
    

    
    
    
    
    // =======================================================
    // MARK: -  this is the otp part
    // =======================================================
    
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
    
    
    
    
    
   
    
    
    
    
    
}

// MARK: - for the onbarding pages to only start for new users

extension UserDefaults {
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    var hasSeenOnboarding: Bool {
        get {
            return bool(forKey: Keys.hasSeenOnboarding)
        }
        set {
            set(newValue, forKey: Keys.hasSeenOnboarding)
        }
    }
}
