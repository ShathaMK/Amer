//
//  NotificationView.swift
//  Amer
//
//  Created by Shaima Alhussain on 17/06/1446 AH.
//

import SwiftUI

struct NotificationView: View {
    @State private var inputText: String = "" // State variable to hold the text
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 30){
                    Text("Notification")
                        .font(Font.system(size: 30))
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.leading, 20)
                        .padding(.top,60)
                    //                        .padding(.trailing, 200)
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(hex:0xE8F6FF))
                        .frame(width: 330)
                        .padding(.top, -10)
                    VStack (spacing: 16){
                        ZStack{
                            Rectangle()
                                .fill(Color("Background"))
                                .frame(width: 325, height: 80)
                                .cornerRadius(20)
                            Text("Mom Monira wants Water")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.font)
                                .padding(.trailing, 10)
                            
                            
                                .overlay(
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Color.darkBlue)
                                        .scaledToFit()
                                        .font(Font.system(size: 25))
                                        .frame(width: 22, height: 25.14)
                                        .padding(.trailing,265))
                            
                            Text("Now")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading,250)
                            
                        }
                        
                        ZStack{
                            Rectangle()
                                .fill(Color("Background"))
                                .frame(width: 325, height: 80)
                                .cornerRadius(20)
                            Text("Mom Monira wants to eat")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.font)
                                .padding(.trailing, 10)
                            
                            
                                .overlay(
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Color.darkBlue)
                                        .scaledToFit()
                                        .font(Font.system(size: 25))
                                        .frame(width: 22, height: 25.14)
                                        .padding(.trailing,265))
                            
                            Text("Now")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading,250)
                            
                        }
                        
                        ZStack{
                            Rectangle()
                                .fill(Color("Background"))
                                .frame(width: 325, height: 80)
                                .cornerRadius(20)
                            Text("Mom Monira wants to \n shower")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.font)
                                .padding(.trailing, 10)
                            
                            
                                .overlay(
                                    Image(systemName: "bell")
                                        .foregroundColor(Color.darkBlue)
                                        .scaledToFit()
                                        .font(Font.system(size: 25))
                                        .frame(width: 22, height: 25.14)
                                        .padding(.trailing,265))
                            
                            Text("2 Min")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading,250)
                            }
                        ZStack{
                            Rectangle()
                                .fill(Color("Background"))
                                .frame(width: 325, height: 80)
                                .cornerRadius(20)
                            Text("Mom Monira wants the  \nwheelchair")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.font)
                                .padding(.trailing, 10)
                            
                            
                                .overlay(
                                    Image(systemName: "bell")
                                        .foregroundColor(Color.darkBlue)
                                        .scaledToFit()
                                        .font(Font.system(size: 25))
                                        .frame(width: 22, height: 25.14)
                                        .padding(.trailing,265))
                            
                            Text("5 Min")
                                .font(Font.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading,250)
                            
                        }
                    }
                    .padding(.top,6)
                }.toolbar{
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination: Onboarding_1()){
                            HStack{
                                Image("Assistant_user")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text("Hello Mohamed Saleh")
                                    .foregroundColor(Color.font)
                                    .font(Font.system(size: 16))
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination:Onboarding_1()){
                            Image("AddButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.leading,80)
                            //                        برضو الدستنيشن غلط بس حطيته عشان يشتغل
                        }
                        
                        
                    }
                }
            }
            
        }
    }
}
#Preview {
    NotificationView()
}
