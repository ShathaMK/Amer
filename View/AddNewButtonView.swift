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
    @EnvironmentObject var vm: ButtonsViewModel// Make sure this is injected into the view
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
                    
                    VStack(spacing: 16) {
                        ZStack {
                            Rectangle()
                                .frame(width: 106, height: 106)
                                .cornerRadius(20)
                                .foregroundStyle(vm.selectedColor)
                                .shadow(radius: 4, y: 4)
                            
                            Text("\(vm.selectedIcon)")
                                .font(.system(size: userVM.scaledFont(baseSize: 54))) // Dynamic font scaling
                        }
                        
                        Text("\(vm.currentLabel)")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                    }
                    .padding()
                    
                    VStack {
                        Text("Button Label")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .padding(.trailing, 180)
                        
                        ZStack {
                            TextField("Enter Button Label", text: $vm.currentLabel)
                                .padding()
                                .frame(width: 290, height: 45)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                    }
                    
                    VStack {
                        Text("Icon")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .padding(.trailing, 250)
                        
                        ZStack {
                            Image("Emoji")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 230)
                            
                            EmojiTextFieldWrapper(text: $vm.selectedIcon)
                                .padding()
                                .frame(width: 290, height: 45)
                                .cornerRadius(4)
                                .onChange(of: emojiText) {
                                    // Limit the length of the text to maxLength
                                    if emojiText.count > maxLength {
                                        emojiText = String(emojiText.prefix(maxLength))
                                    }
                                }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                    }
                    .padding()
                    
                    HStack {
                        ColorPicker("Button Color", selection: $vm.selectedColor)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundStyle(Color("FontColor"))
                            .padding(.trailing, 36)
                            .padding(.leading, 41)
                    }
                    .padding()
                    
                    Button(action: {
                        userVM.triggerHapticFeedback() // Trigger haptic feedback
                        
                        // Check if button details are not empty before saving
                        guard !vm.currentLabel.isEmpty, !vm.selectedIcon.isEmpty else {
                            print("Button details can't be empty")
                            return
                        }
                        
                        // Create a new button instance with the details
                        let newButton = Buttons(
                            id: buttonToEdit?.id ?? CKRecord.ID(), // Use CKRecord.ID for CloudKit compatibility
                            label: vm.currentLabel,
                            icon: vm.selectedIcon,
                            color: vm.selectedColor,
                            isDisabled: false
                        )
                        
                        // Check if editing an existing button or adding a new one
                        if let buttonToEdit = buttonToEdit {
                            vm.editButton(oldButton: buttonToEdit, with: newButton)
                        } else {
                            vm.addButton(newButton: newButton)
                        }
                        
                        print("Saved button: \(newButton)")
                        
                        // Navigate to the next screen
                        isNavigating = true
                    }) {
                        Text("Add")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("DarkBlue"))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    .navigationDestination(isPresented: $isNavigating) {
                        RemoteView(vm: _vm).navigationBarBackButtonHidden(true)
                    }
                    
                    NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)) {
                        Text("Cancel")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20))) // Dynamic font scaling
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("LightBlue"))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .onAppear {
            if buttonToEdit == nil {
                vm.resetCurrentButton()
            }
        }
        
    }
    
}
    

#Preview {
    AddNewButtonView()
}
