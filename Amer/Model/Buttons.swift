//
//  Button.swift
//  Amer
//
//  Created by Shatha Almukhaild on 15/06/1446 AH.
//

import Foundation
import SwiftUICore
struct Buttons: Identifiable{
    var id = UUID()
    var label: String
    var icon: String
    var color: Color
    var isDisabled: Bool
    init(id: UUID = UUID(), label: String, icon: String, color: Color, isDisabled: Bool) {
        self.id = id
        self.label = label
        self.icon = icon
        self.color = color
        self.isDisabled = isDisabled
    }
    
}
