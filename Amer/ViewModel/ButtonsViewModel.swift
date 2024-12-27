//
//  ButtonsViewModel.swift
//  Amer
//
//  Created by Shaima Alhussain on 22/06/1446 AH.
//

import Foundation
import SwiftUI
class ButtonsViewModel: ObservableObject{
    @Published var buttons: [Buttons] = [] // array to store multiple buttons
    @Published var currentLabel: String = ""
    @Published var selectedIcon: String = ""
    @Published var selectedColor: Color = Color("DarkBlue")// Default color

    @Published var selectedButton: Buttons? // optional to track selected button
    
    
    
    func addButton(newButton:Buttons){
        let newButton = Buttons(
            label: currentLabel,
            icon: selectedIcon,
            color: selectedColor)
        buttons.append(newButton)
        objectWillChange.send()
    }
    
    func deleteButton(_ button: Buttons){
        if let index = buttons.firstIndex(where: { $0.id == button.id }){
            buttons.remove(at: index)
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
    
    func editButton(oldButton: Buttons, with newButton:Buttons){
        if let index = buttons.firstIndex(where: { $0.id == oldButton.id}){
            buttons[index] = newButton
            objectWillChange.send()
            print("Updated Buttons: \(buttons)")
        }
        else {
            print("Button not found")
        }
        
    }
    
    func resetCurrentButton() {
        currentLabel = ""
        selectedIcon = ""
        selectedColor = Color("DarkBlue")
    }
    
    
    
    
    
}
    
    
    
    
    
    
    

