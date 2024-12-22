//
//  AddNewButtonView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI

struct AddNewButtonView: View {
    @State private var ButtonLabel: String = ""
    @State private var showPopUp = false

        // @FocusState private var ButtonLabelField: Bool = false

    var body: some View {
        VStack {
            Text("New Button").font(.custom("Tajawal-Bold", size: 40)).foregroundStyle(Color("FontColor"))
            
            VStack(spacing:16){
                ZStack{
                    Rectangle().frame(width: 106,height: 106).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                    Text("💧").font(.system(size: 54))
                }
                Text("Water").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor"))
                
            }
            .padding()
            VStack{
                Text("Button Label").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,180)
                TextField("Enter Button Label", text: $ButtonLabel)
                    .frame(width: 290, height: 45)
                //  .background(Color("Background"))
                    .border(.gray)
            }
            
            .padding()
            VStack{
                Text("Icon").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,253)
                TextField("💧", text: $ButtonLabel)
                    .frame(width: 290, height: 45)
                //  .background(Color("Background"))
                    .border(.gray)
            }
            .padding()
            HStack{
                Text("Button Color").font(Font.custom("Tajawal-Bold", size: 20)).foregroundStyle(Color("FontColor")).padding(.trailing,180)
            }
            
           
    
            
        }
    }
}

#Preview {
    AddNewButtonView()
}
