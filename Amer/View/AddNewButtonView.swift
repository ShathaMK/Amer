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
    @EnvironmentObject var buttonsVM: ButtonsViewModel// Make sure this is injected into the view
    @EnvironmentObject var userVM: UserViewModel // For dynamic font scaling and haptics
    @State private var ButtonLabel: String = ""
    @State private var showPopUp = false
    @State var ColorSelected = Color("DarkBlue")
    @State private var emojiText: String = ""
    let maxLength=1
    var buttonToEdit: Buttons?
    @State private var keyboardHeight: CGFloat = 0
    @State private var isNavigating = false // State to control navigation
    
    
    // @FocusState private var ButtonLabelField: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    Text("New Button")
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 40))) // Dynamic font scaling
                        .foregroundStyle(Color("FontColor"))
                    
                    Spacer()
                    
                    VStack() {
                        ZStack {
                            Rectangle()
                                .frame(width: 106, height: 106)
                                .cornerRadius(20)
                                .foregroundStyle(buttonsVM.selectedColor)
                                .shadow(radius: 4, y: 4)
                            
                            Text("\(buttonsVM.selectedIcon)")
                                .font(.system(size: userVM.scaledFont(baseSize: 54))) // Dynamic font scaling
                        }
                        
                        Spacer()
                            .frame(height: 32)
                        
                        Text("\(buttonsVM.currentLabel)")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                    }
//                    .padding()
                    Spacer()
                        .frame(height: 32)
                    
                    VStack {
                        Text("Button Label")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        TextField("Enter Button Label", text: $buttonsVM.currentLabel)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .frame(height: 45)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    VStack {
                        Text("Icon")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        ZStack {
                            Image("Emoji")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 230)
                            
                            EmojiTextFieldWrapper(text: $buttonsVM.selectedIcon)
                                .padding()
                                .frame(height: 45)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                                .padding(.horizontal, 20)
                                .onChange(of: emojiText) {
                                    // Limit the length of the text to maxLength
                                    if emojiText.count > maxLength {
                                        emojiText = String(emojiText.prefix(maxLength))
                                    }
                                }
                        }
//                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                    }
//                    .padding()
                    
                    Spacer()
                        .frame(height: 32)
                    
                    HStack {
                        ColorPicker("Button Color", selection: $buttonsVM.selectedColor)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
//                    .padding()
                    
                    Spacer()
                        .frame(height: 60)
                    
                    //MARK: - the ADD button
                    
                    Button(action: {
                        userVM.triggerHapticFeedback() // Trigger haptic feedback
                        
                        // Check if button details are not empty before saving
                        guard !buttonsVM.currentLabel.isEmpty, !buttonsVM.selectedIcon.isEmpty else {
                            print("Button details can't be empty")
                            return
                        }
                        
                        // Create a new button instance with the details
                        let newButton = Buttons(
                            id: buttonToEdit?.id ?? CKRecord.ID(), // Use CKRecord.ID for CloudKit compatibility
                            label: buttonsVM.currentLabel,
                            icon: buttonsVM.selectedIcon,
                            color: buttonsVM.selectedColor,
                            isDisabled: false
                        )
                        
                        // Check if editing an existing button or adding a new one
                        if let buttonToEdit = buttonToEdit {
                            buttonsVM.editButton(oldButton: buttonToEdit, with: newButton)
                        } else {
                            buttonsVM.addButton(newButton: newButton)
                        }
                        
                        print("Saved button: \(newButton)")
                        
                        // Navigate to the next screen
                        isNavigating = true
                    }) {
                        Text("Add")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                    }
                    .buttonStyle(BlueButton())
                    .shadow(radius: 7, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .navigationDestination(isPresented: $isNavigating) {
                        RemoteView()
                            .environmentObject(buttonsVM)
//                        RemoteView(buttonsVM: buttonsVM)
                    }
                    
                    //MARK: - the cancel button
                    
                    NavigationLink(destination: RemoteView()) {
                        Text("Cancel")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                    }
                    .buttonStyle(cancelGrayBlue())
                    .shadow(radius: 7, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    
//                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onAppear {
            if buttonToEdit == nil {
                buttonsVM.resetCurrentButton()
            }
        }
        
    }
    
}
    

#Preview {
    AddNewButtonView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
}
