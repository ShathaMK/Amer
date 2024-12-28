//
//  FontSizeManager.swift
//  Amer
//
//  Created by Shaima Alhussain on 26/06/1446 AH.
//

import Foundation
import SwiftUI
import Combine

class FontSizeManager: ObservableObject {
    @Published var fontSize: CGFloat = 20 // Default font size

    func updateFontSize(to size: String) {
        switch size {
        case "Small":
            fontSize = 14
        case "Medium":
            fontSize = 20
        case "Large":
            fontSize = 26
        default:
            fontSize = 20
        }
    }
}
