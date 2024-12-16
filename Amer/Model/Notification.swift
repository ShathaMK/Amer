//
//  Notification.swift
//  Amer
//
//  Created by Shatha Almukhaild on 15/06/1446 AH.
//

import Foundation
struct Notification: Identifiable {
    var id = UUID()
    var userID : String
    var message : String
    var timestamp: Date
    var statues : String // read or unread
    
    
    init(id: UUID = UUID(), userID: String, message: String, timestamp: Date, statues: String) {
        self.id = id
        self.userID = userID
        self.message = message
        self.timestamp = timestamp
        self.statues = statues
    }
}
