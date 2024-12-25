//
//  UserViewModel.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.
//

import Foundation
import CloudKit

// protocol UserViewModel: ObservableObject {
//    var user: User { get }
//    var isSignedInToiCloud: Bool { get }
//    var error: String { get }
//    func signInToiCloud()
//    func signOutFromiCloud()
//}



class UserViewModel: ObservableObject {
    //    @Published var user: User
    //    @Published var isSignedInToiCloud: Bool
    //    @Published var error: String
    //
    //    init() {
    //        self.user = User()
    //        self.isSignedInToiCloud = false
    //        self.error = ""
    //    }
    
    @Published var otp: [String] = ["", "", "", ""] // For 6-digit OTP
    @Published var isValidOTP: Bool = false

    // Validate the OTP
    func validateOTP() {
       let otpString = otp.joined()
       if otpString.count == 4 {
           
           
           // Example validation logic
           isValidOTP = otpString == "1234" // Replace with your actual validation logic
           
           
       } else {
           isValidOTP = false
       }
    }

    // Clear the OTP
    func clearOTP() {
       otp = ["", "", "", ""]
    }
    
    
    
    // -MARK: this here is to check the connection of the icloud account
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userPhone: String?
    
    init() {
        getiCloudStatus()
    }
    
    private func getiCloudStatus(){
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
        
        enum CloudKitError: String, LocalizedError {
            case iCloudAccountNotFound
            case iCloudAccountNotDetermined
            case iCloudAccountRestricted
            case iCloudAccountUnknown
        }
        
        
        
        
        
        
        
        
        
        
    }
    
}

