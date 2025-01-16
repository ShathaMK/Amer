//
//  AddNewButtonView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI

import Combine
import CloudKit

// Custom UITextField subclass to force emoji keyboard
class EmojiTextField: UITextField {
    override var textInputContextIdentifier: String? {
        // Required to enable custom keyboard behavior for iOS 13+
        return ""
    }

    override var textInputMode: UITextInputMode? {
        // Force the emoji keyboard by filtering active input modes
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

// SwiftUI wrapper for the custom UITextField
struct EmojiTextFieldWrapper: UIViewRepresentable {
    @Binding var text: String
   
    func makeUIView(context: Context) -> EmojiTextField {
        let textField = EmojiTextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .left
   //     textField.placeholder = Image("Emoji")
        textField.tintColor = .clear // Hide the cursor for better UX
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: EmojiTextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        @objc func textChanged(sender: UITextField) {
            // Allow only emoji characters
            sender.text = sender.text?.filter { $0.isEmoji }
            text = sender.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}

extension Character {
    /// Check if the character is an emoji
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || scalar.properties.isEmojiPresentation)
    }
}
extension UITextField {
    /// Places the cursor at a specific index
    func setCursorPosition(_ index: Int) {
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: index) else { return }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
}
    

struct AddNewButtonView: View {
    @EnvironmentObject var buttonsVM: ButtonsViewModel // ViewModel for buttons
    @EnvironmentObject var userVM: UserViewModel // ViewModel for user preferences

    @State private var localLabel: String = "" // Temporary local state for the button label
    @State private var localIcon: String = "" // Temporary local state for the emoji
    @State private var localColor: Color = Color("DarkBlue") // Temporary local state for the button color
    @State private var isNavigating = false // Navigation state

    let maxLength = 1
    var buttonToEdit: Buttons?

    var body: some View {
        NavigationStack {

                VStack {
                    Spacer()
                    
                    Text("New Button")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 40)))
                        .foregroundStyle(Color("FontColor"))
                    
                    Spacer()
                    
                    // Button Preview
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 106, height: 106)
                                .cornerRadius(20)
                                .foregroundStyle(localColor)
                                .shadow(radius: 4, y: 4)
                            
                            Text(localIcon.isEmpty ? "" : localIcon) // Default emoji if empty
                                .font(.system(size: userVM.scaledFont(baseSize: 54)))
                        }
                        
                        Spacer()
                            .frame(height: 32)
                        
                        Text(localLabel.isEmpty ? "" : localLabel) // Default label if empty
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("FontColor"))
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // Input Fields
                    VStack {
                        Text("Button Label")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        TextField("Enter Button Label", text: $localLabel)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .frame(height: 45)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    VStack {
                        Text("Icon")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        ZStack {
                            Image("Emoji")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(height: 45)
                                .padding(.horizontal, 30)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                .padding(.horizontal, 20)

                            EmojiTextFieldWrapper(text: $localIcon)
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                                .padding()
                                .frame(height: 45)
                                .padding(.horizontal, 20)
                                .onChange(of: localIcon) { newValue in
                                    if newValue.count > maxLength {
                                        localIcon = String(newValue.prefix(maxLength))
                                    }
                                }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // Color Picker
                    HStack {
                        ColorPicker("Button Color", selection: $localColor)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 60)
                    
                    // Add Button
                    Button(action: {
                        userVM.triggerHapticFeedback()
                        
                        // Validate input
                        guard !localLabel.isEmpty, !localIcon.isEmpty else {
                            print("Button details can't be empty")
                            return
                        }
                        
                        // Create new button
                        let newButton = Buttons(
                            id: buttonToEdit?.id ?? CKRecord.ID(),
                            label: localLabel,
                            icon: localIcon,
                            color: localColor,
                            isDisabled: false
                        )
                        
                        // Update ViewModel
                        if let buttonToEdit = buttonToEdit {
                            buttonsVM.editButton(oldButton: buttonToEdit, with: newButton)
                        } else {
                            buttonsVM.addButton(newButton: newButton)
                        }
                        
                        print("Saved button: \(newButton)")
                        
                        // Navigate
                        DispatchQueue.main.async {
                            isNavigating = true
                        }
                    }) {
                        Text("Add")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                    }
                    .buttonStyle(BlueButton())
                    .shadow(radius: 7, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .navigationDestination(isPresented: $isNavigating) {
                        RemoteView()
                            .environmentObject(buttonsVM)
                    }
                    
                    //MARK: -  Cancel Button
                    NavigationLink(destination: RemoteView()
                        .environmentObject(userVM)
                        .environmentObject(buttonsVM)) {
                        Text("Cancel")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                    }
                    .buttonStyle(cancelGrayBlue())
                    .shadow(radius: 7, x: 0, y: 5)
                    .padding(.horizontal, 20)
                }
            
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            userVM.hideKeyboard()
        }
        .onAppear {
            // Initialize local state with existing data if editing
            if let buttonToEdit = buttonToEdit {
                localLabel = buttonToEdit.label
                localIcon = buttonToEdit.icon
                localColor = buttonToEdit.color
            }
        }
    }
}

    

#Preview {
    AddNewButtonView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
}
