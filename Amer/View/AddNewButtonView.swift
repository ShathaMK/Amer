//
//  AddNewButtonView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI

import Combine

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
        @State private var ButtonLabel: String = ""
        @State private var showPopUp = false
        @State var ColorSelected = Color("DarkBlue")
        @State private var emojiText: String = ""
        let maxLength=1

        
        // @FocusState private var ButtonLabelField: Bool = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Text("New Button").font(.custom("Tajawal-Bold", size: 40)).foregroundStyle(Color("FontColor"))
                    
                    VStack(spacing:16){
                        ZStack{
                            Rectangle().frame(width: 106,height: 106).cornerRadius(20).foregroundStyle(ColorSelected).shadow(radius: 4, y: 4)
                            Text("\(emojiText)").font(.system(size: 54))
                        }
                        Text("\(ButtonLabel)").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor"))
                        
                    }
                    .padding()
                    VStack{
                        Text("Button Label").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,180)
                        ZStack{
                            TextField(" Enter Button Label", text: $ButtonLabel)
                                .padding()
                                .frame(width: 290, height: 45)
                            
                            //  .background(Color("Background"))
                            // .border(.gray)
                        }.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                    }
                    
                    //  .padding()
                    VStack{
                        Text("Icon").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,250)
                        //EmojiTextField($text)
                        ZStack{
                            Image("Emoji").resizable().frame(width: 24,height: 24).padding(.leading,230)
                            
                            EmojiTextFieldWrapper(text: $emojiText)
                                .padding()
                                .frame(width: 290, height: 45)
                                .cornerRadius(4)
                                .onChange(of: emojiText) {
                                    // Limit the length of the text to maxLength
                                    if emojiText.count > maxLength {
                                        emojiText = String(emojiText.prefix(maxLength))
                                    }
                                }
                        }.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                        //.font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,253)
                        
                    }
                    .padding()
                    HStack{
                        //   Text("Button Color").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,180)
                        ColorPicker("Button Color",selection: $ColorSelected).font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,36).padding(.leading,41)
                        
                    }
                    .padding()
                    NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)
                     ){
                      
                        Button("Add") {
                            //bool2 = true
                        }
                        .font(.custom("Tajawal-Bold", size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("DarkBlue"))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        
                    }

                    NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)
                    ){
                        Button("Cancel") {
                            //                    bool2 = true
                        }
                        .font(.custom("Tajawal-Bold", size: 20))
                        .foregroundColor(Color("DarkBlue"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("LightBlue"))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    }
                                 
                    
                    
                }
            }
              
                    
                
                }
                
             
            
        }
    

#Preview {
    AddNewButtonView()
}
