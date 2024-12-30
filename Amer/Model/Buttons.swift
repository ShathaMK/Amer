//
//  Button.swift
//  Amer
//
//  Created by Shatha Almukhaild on 15/06/1446 AH.
//

import Foundation
import SwiftUICore
import CloudKit

struct Buttons: Identifiable {
    let id: CKRecord.ID
    let label: String
    let icon: String
    let color: Color
    var isDisabled: Bool

    // Custom initializer
    init(id: CKRecord.ID = CKRecord.ID(), label: String, icon: String, color: Color, isDisabled: Bool) {
        self.id = id
        self.label = label
        self.icon = icon
        self.color = color
        self.isDisabled = isDisabled
    }

    // If you're still fetching data from CKRecord
    init(record: CKRecord) {
        self.id = record.recordID
        self.label = record["label"] as? String ?? "Default Label"
        self.icon = record["icon"] as? String ?? "Default Icon"
        if let colorString = record["color"] as? String {
                self.color = Color(hex: colorString) ?? Color("DarkBlue")
            } else {
                self.color = Color("DarkBlue") // Default fallback
            }
        self.isDisabled = record["isDisabled"] as? Bool ?? false
    }
}
