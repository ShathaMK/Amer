//
//  NotificationView.swift
//  Amer
//
//  Created by Shaima Alhussain on 17/06/1446 AH.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        NavigationStack {
            
            ScrollView{
                
                VStack{
                    ZStack{
                        Rectangle()
                            .fill(Color.grayLight)
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
                    
                }
            }.toolbar{

                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination: ProfileView()){
                        Image("image2")
                              
                    }
                }
             
                
                
            }
        }
    }
}

#Preview {
    NotificationView()
}
