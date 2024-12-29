//
//  HapticFeedback.swift .swift
//  Amer
//
//  Created by Shaima Alhussain on 26/06/1446 AH.
//

import Foundation
import UIKit

class HapticFeedback {
    static let shared = HapticFeedback()

    func triggerHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}
