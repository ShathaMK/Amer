//
//  RemoteView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI

struct RemoteView: View {
    var body: some View {
        
        NavigationStack {
            VStack {

                Text("Hello, Mama Munerah")
                    .font(Font.custom("Tajawal-Bold", size: 28)).foregroundStyle(Color("FontColor"))
                    .padding(.trailing,100)

                Divider()
                    .frame(width: 330,height: 2)
                    .overlay(Color(hex:0xE8F6FF))
                    .padding()
                
                VStack(spacing:32) {
                    HStack(spacing: 32){
                      
                            Button(action:{
                                
                            }
                            ){
                                VStack(spacing:8){
                                    ZStack{
                                        Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                        Text("💧").font(.system(size: 30)).foregroundStyle(Color("FontColor"))
                                    }
                                    Text("Water").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                                }
                            }
                         
                        
                        
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("🛁").font(.system(size: 30))
                                }
                                Text("Shower").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("🍽️").font(.system(size: 30))
                                }
                                Text("Food").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        
                    }
                    
                    HStack(spacing: 32){
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("💊").font(.system(size: 30))
                                }
                                Text("Medicean").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("👚").font(.system(size: 30))
                                }
                                Text("Clothes").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("🕌").font(.system(size: 30))
                                }
                                Text("Pray").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        
                    }
                    HStack(spacing: 32){
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("🚗").font(.system(size: 30))
                                }
                                Text("Go Out").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color.red).shadow(radius: 4, y: 4)
                                    Text("🚑").font(.system(size: 30))
                                }
                                Text("Emergency").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        Button(action:{
                            
                        }
                        ){
                            VStack(spacing:8){
                                ZStack{
                                    Rectangle().frame(width: 74,height: 74).cornerRadius(20).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                    Text("👩‍🦼").font(.system(size: 30))
                                }
                                Text("Wheelchair").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                            }
                        }
                        
                    }
                    Button(action:{
                        
                    }
                    ){
                        VStack(spacing:8){
                            ZStack{
                                Circle().frame(width: 114,height: 114).foregroundStyle(Color("DarkBlue")).shadow(radius: 4, y: 4)
                                Text("🔔").font(.system(size: 50))
                                
                            }
                            Text("Bell").font(Font.custom("Tajawal-Bold", size: 16)).foregroundStyle(Color("FontColor"))
                        }
                    }
                }
                
            }.padding(.bottom,50)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: ButtonListView().navigationBarBackButtonHidden(true)
){
                            //  Text("AddButton")
                            Image("AddButton").resizable().frame(width: 43,height: 43).ignoresSafeArea()
                            }
                        
                        }
                        

                        ToolbarItem(placement: .topBarLeading){
                            NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)
){
                                //  Text("ReciverIcon")
                               Image("Reciver_user").resizable().frame(width: 43,height: 43)
                            }                            //
                        }

                    }
        }
   


    }
}

#Preview {
    RemoteView()
}


// to pick color in hex format Color(hex:0x000000) used like this
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}
// to make the interfaces responsive to each device we use this extension
// to use UIScreen.screenWidth for example
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
