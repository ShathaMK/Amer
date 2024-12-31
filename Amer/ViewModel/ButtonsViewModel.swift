//
//  ButtonsViewModel.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.
//

import Foundation
import SwiftUI
import CloudKit

class ButtonsViewModel: ObservableObject{
    @Published var buttons: [Buttons] = [] // array to store multiple buttons
    @Published var currentLabel: String = ""
    @Published var selectedIcon: String = ""
    @Published var selectedColor: Color = Color("DarkBlue")// Default color

    @Published var selectedButton: Buttons? // optional to track selected button
    
    
    // Add Button to CloudKit
    func addButton(newButton: Buttons) {
        // Convert the button's properties to a CKRecord
        let newRecord = CKRecord(recordType: "Buttons")
        newRecord["label"] = newButton.label
        newRecord["icon"] = newButton.icon
        newRecord["color"] = newButton.color.toHexString() // Assuming `toHexString()` exists for Color
        newRecord["isDisabled"] = newButton.isDisabled

        // Save the new record to CloudKit
        CKContainer.default().publicCloudDatabase.save(newRecord) { record, error in
            if let error = error {
                print("Error saving button: \(error.localizedDescription)")
                return
            }

            // If saved successfully, create a Buttons object from the CKRecord
            if let savedRecord = record {
                let savedButton = Buttons(record: savedRecord)

                // Assuming you have an array of buttons locally
                self.buttons.append(savedButton) // Add to local data source
                DispatchQueue.main.async {
                    self.objectWillChange.send() // Notify view to update
                }
            }
        }
    }
//    func addButton(newButton:Buttons){
//        let newButton = Buttons(
//            label: currentLabel,
//            icon: selectedIcon,
//            color: selectedColor,
//            isDisabled: false)
//        buttons.append(newButton)
//        objectWillChange.send()
//    }
    
    func deleteButton(_ button: Buttons){
        if let index = buttons.firstIndex(where: { $0.id == button.id }){
            buttons.remove(at: index)
        }
    }
    
    func toggleDisableButton(_ button: Buttons) {
         if let index = buttons.firstIndex(where: { $0.id == button.id }) {
             buttons[index].isDisabled.toggle()
         }
     }
    
    func loadButton(_ button: Buttons) {
        guard let index = buttons.firstIndex(where: { $0.id == button.id }) else {
            print("No matching button found with ID: \(button.id)")
            return
        }
            print("Loaded button for editing: \(buttons[index])")
            currentLabel = button.label
            selectedIcon = button.icon
            selectedColor = button.color
            
            
        }
    // Edit an existing button in CloudKit
    func editButton(oldButton: Buttons, with newButton: Buttons) {
        // Fetch the CKRecord corresponding to the oldButton
        let recordID = oldButton.id
        let database = CKContainer.default().publicCloudDatabase

        database.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                print("Error fetching button to edit: \(error.localizedDescription)")
                return
            }

            guard let recordToUpdate = record else { return }

            // Update the record fields
            recordToUpdate["label"] = newButton.label
            recordToUpdate["icon"] = newButton.icon
            recordToUpdate["color"] = newButton.color.toHexString()
            recordToUpdate["isDisabled"] = newButton.isDisabled

            // Save the updated record to CloudKit
            database.save(recordToUpdate) { savedRecord, saveError in
                if let saveError = saveError {
                    print("Error saving updated button: \(saveError.localizedDescription)")
                    return
                }

                // If saved successfully, update your local data model
                if let savedRecord = savedRecord {
                    let updatedButton = Buttons(record: savedRecord)

                    // Find the index of the old button and update it
                    if let index = self.buttons.firstIndex(where: { $0.id == oldButton.id }) {
                        self.buttons[index] = updatedButton
                        DispatchQueue.main.async {
                            self.objectWillChange.send() // Notify view to update
                        }
                    }
                }
            }
        }
    }
    
//    func editButton(oldButton: Buttons, with newButton:Buttons){
//        if let index = buttons.firstIndex(where: { $0.id == oldButton.id}){
//            buttons[index] = newButton
//            objectWillChange.send()
//            print("Updated Buttons: \(buttons)")
//        }
//        else {
//            print("Button not found")
//        }
//        
//    }
    
    func resetCurrentButton() {
        currentLabel = ""
        selectedIcon = ""
        selectedColor = Color("DarkBlue")
    }
    
    
    
    
    
}
    
    
    
    

extension Color {
    /// Initialize a Color from a hex string.
    init?(hex: String) {
           var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
           hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

           var rgb: UInt64 = 0
           guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

           switch hexSanitized.count {
           case 6: // #RRGGBB
               let red = Double((rgb & 0xFF0000) >> 16) / 255.0
               let green = Double((rgb & 0x00FF00) >> 8) / 255.0
               let blue = Double(rgb & 0x0000FF) / 255.0
               self.init(red: red, green: green, blue: blue)

           case 8: // #RRGGBBAA
               let red = Double((rgb & 0xFF000000) >> 24) / 255.0
               let green = Double((rgb & 0x00FF0000) >> 16) / 255.0
               let blue = Double((rgb & 0x0000FF00) >> 8) / 255.0
               let alpha = Double(rgb & 0x000000FF) / 255.0
               self.init(red: red, green: green, blue: blue, opacity: alpha)

           default:
               return nil // Invalid format
           }
       }

    /// Convert a Color to a hex string (RGBA).
    func toHexString() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)

        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
}


    
    

