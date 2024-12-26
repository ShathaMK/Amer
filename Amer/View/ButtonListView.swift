//
//  ButtonListView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI


struct ButtonListView: View {
    var body: some View {
        
       NavigationStack {
           
           ScrollView{
               Text("Active").font(Font.custom("Tajawal-Bold", size: 22)).foregroundStyle(Color("DarkGreen")).padding(.trailing,300)
               ZStack{
                   Rectangle().frame(width: 364,height: 248).foregroundStyle(Color("Background")).cornerRadius(20)
                   VStack(spacing:16) {
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
                   }
               }
               .padding()
               Text("Disabled").font(Font.custom("Tajawal-Bold", size: 22)).foregroundStyle(Color.red).padding(.trailing,280)
               
               ZStack{
                   Rectangle().frame(width: 364,height: 248).foregroundStyle(Color("Background")).cornerRadius(20)
                   VStack(spacing:16) {
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
                       
             
                   }
               }
           }
           
//           .navigationBarTitle("Button List").font(.custom("Tajawal-Bold", size: 30))
               .toolbar {
                   ToolbarItem(placement: .topBarTrailing){
                       NavigationLink(destination: AddNewButtonView().navigationBarBackButtonHidden(true)
                        ){
                        // Text("AddButton")
                        Image("AddButton").resizable().frame(width: 43,height: 43).ignoresSafeArea()
                       }
                   
                   }
                   
                   ToolbarItem(placement: .principal){
                      
                       Text("Button List").font(.custom("Tajawal-Bold", size: 30)).foregroundStyle(Color("FontColor"))
                                                  //
                   }
                   ToolbarItem(placement: .topBarLeading){
                       NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)
                       ){
                         
                           Image(systemName: "chevron.backward").resizable().frame(width: 15,height: 25.5).foregroundStyle(Color("DarkBlue"))
                       }                            //
                   }
               }
           
           
        }
    }
}

#Preview {
    ButtonListView()
        
}
