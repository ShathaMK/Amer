//
//  ButtonListView.swift
//  Amer
//
//  Created by Shatha Almukhaild on 18/06/1446 AH.
//

import SwiftUI


struct ButtonListView: View {
    @EnvironmentObject var vm: ButtonsViewModel
    var body: some View {
        
       NavigationStack {
           
          
               Text("Active").font(Font.custom("Tajawal-Bold", size: 22)).foregroundStyle(Color("DarkGreen")).padding(.trailing,300)
           
           ZStack{
               
               Rectangle().frame(width: 364,height: 270).foregroundStyle(Color("Background")).cornerRadius(20)
               ScrollView{
               LazyVGrid(columns: [
                GridItem(.fixed(76),spacing: 32),
                GridItem(.fixed(76),spacing: 32),
                GridItem(.fixed(76),spacing: 32)
               ], spacing: 32) {
                   ForEach(vm.buttons) { button in
                       Button(action: {
                           // Define button action here
                           print("Button \(button.label) tapped")
                       }) {
                           VStack(spacing: 8) {
                               Text(button.icon)
                                   .font(.system(size: 30))
                                   .frame(width: 74,height: 74)
                                   .background(Color(button.color))
                                   .cornerRadius(20)
                                   .shadow(radius: 4, y: 4)
                               Text(button.label)
                                   .font(Font.custom("Tajawal-Bold", size: 16))
                                   .foregroundStyle(Color("FontColor"))
                           }
                       }
                   }
               }.padding(.top,20)
           }
               }
               .padding()
           
               Text("Disabled").font(Font.custom("Tajawal-Bold", size: 22)).foregroundStyle(Color.red).padding(.trailing,280)
               
               ZStack{
                   Rectangle().frame(width: 364,height: 270).foregroundStyle(Color("Background")).cornerRadius(20)
                   ScrollView{
                       LazyVGrid(columns: [
                        GridItem(.fixed(76),spacing: 32),
                        GridItem(.fixed(76),spacing: 32),
                        GridItem(.fixed(76),spacing: 32)
                       ], spacing: 32) {
                        
                           ForEach(vm.buttons) { button in
                               Button(action: {
                                   // Define button action here
                                   print("Button \(button.label) tapped")
                               }) {
                                   VStack(spacing: 8) {
                                       Text(button.icon)
                                           .font(.system(size: 30))
                                           .frame(width: 74,height: 74)
                                           .background(Color(button.color))
                                           .cornerRadius(20)
                                           .shadow(radius: 4, y: 4)
                                       Text(button.label)
                                           .font(Font.custom("Tajawal-Bold", size: 16))
                                           .foregroundStyle(Color("FontColor"))
                                   }
                               }
                           }
                       }.padding(.top,20)
                   }
               }
               .padding()
           
           

               .toolbar {
                   ToolbarItem(placement: .topBarTrailing){
                       NavigationLink(destination: AddNewButtonView().navigationBarBackButtonHidden(true)
                        ){
                        
                        Image("AddButton").resizable().frame(width: 43,height: 43).ignoresSafeArea()
                       }
                   
                   }
                   
                   ToolbarItem(placement: .principal){
                      
                       Text("Button List").font(.custom("Tajawal-Bold", size: 30)).foregroundStyle(Color("FontColor"))
                                                
                   }
                   ToolbarItem(placement: .topBarLeading){
                       NavigationLink(destination: RemoteView().navigationBarBackButtonHidden(true)
                       ){
                         
                           Image(systemName: "chevron.backward").resizable().frame(width: 15,height: 25.5).foregroundStyle(Color("DarkBlue"))
                       }                          
                   }
               }
           
           
        }
    }
}

#Preview {
    ButtonListView().environmentObject(ButtonsViewModel())
}
class ButtonsViewMode: ObservableObject {
    @Published var buttons: [Buttons] = []

    init(sampleData: Bool = false) {
        if sampleData {
            buttons = [
                Buttons(label: "Button 1", icon: "🔑", color: Color.blue),
                Buttons(label: "Button 2", icon: "📞", color: Color.green),
                Buttons(label: "Button 3", icon: "📷", color: Color.red),
                Buttons(label: "Button 4", icon: "🎮", color: Color.purple),
                Buttons(label: "Button 5", icon: "🎵", color: Color.orange),
                Buttons(label: "Button 6", icon: "📁", color: Color.yellow)
            ]
        }
    }
}
