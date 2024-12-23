//
//  Button.swift
//  Amer
//
//  Created by Shatha Almukhaild on 15/06/1446 AH.
//

import Foundation
struct Buttons: Identifiable{
    var id = UUID()
    var label: String
    var icon: String
    var color: String
    
    init(id: UUID = UUID(), label: String, icon: String, color: String) {
        self.id = id
        self.label = label
        self.icon = icon
        self.color = color
    }
    
}
