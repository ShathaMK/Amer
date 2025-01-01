//
//  File.swift
//  Amer
//
//  Created by Shatha Almukhaild on 15/06/1446 AH.
//

import Foundation

//struct User : Identifiable {
//    
//    var id = UUID()
//    var name: String
//    var phoneNumber: String
//    var role: String //Assistance or Seeker
//    
//    init(id: UUID = UUID(), name: String, phoneNumber: String, role: String) {
//        self.id = id
//        self.name = name
//        self.phoneNumber = phoneNumber
//        self.role = role
//    }
//    
//    
//}



import Foundation
import CloudKit
import SwiftUICore

struct User: Identifiable {
    
    var id : CKRecord.ID
    var name: String
    var phoneNumber: String
    var role: String // Assistance or Seeker
    
    init(id: CKRecord.ID, name: String, phoneNumber: String, role: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.role = role
    }
    
    // Initializer to create User from CKRecord
       init(record: CKRecord) {
           self.id = record.recordID
           self.name = record["name"] as? String ?? ""
           self.phoneNumber = record["phoneNumber"] as? String ?? ""
           self.role = record["role"] as? String ?? ""
       }
}

struct Country: Codable {
    var id : Int
    let name: String
    let flag: String
    let code: String
}


