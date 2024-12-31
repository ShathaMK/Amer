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

struct Country: Codable {
    var id : Int
    let name: String
    let flag: String
    let code: String  // e.g., "+1", "+966", etc.
}


struct User: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var role: String // Assistance or Seeker
}
