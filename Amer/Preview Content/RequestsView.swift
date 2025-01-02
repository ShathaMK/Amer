//
//  RequestsView.swift
//  Amer
//
//  Created by Noori on 02/01/2025.
//

import SwiftUI

struct RequestsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var userVM = UserViewModel()
    @EnvironmentObject var memberVM: MembersViewModel
//    @EnvironmentObject var userVM = UserViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(memberVM.requests) { request in
                    HStack {
                        Image("User_Assistant")
                            .resizable()
                            .frame(width: 50, height: 50)

                        VStack(alignment: .leading) {
                            Text(request.name)
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                            Text(request.phone)
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack(){
                            
                            
                            Button(action: {
                                memberVM.addMember(request)
                            }) {
                                
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                        .foregroundColor(Color.white)
                                    
                                    Spacer()
                                    
                                    Text("Add")
                                        .font(.custom("Tajawal-Medium", size: 16))
                                }
                                .padding()
                                
                            }
                            .buttonStyle(LightGreenButton())
                            .frame(width: 90, height: 39)
                            .cornerRadius(8)
                            
                            Spacer()
                                .frame(width: 16)
                            
                            Button(action: {
                                memberVM.deleteRequest(request)
                            }) {
                                
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("ColorRed"))
                                
                            }
                        }
                        
                        
                    }// end hstack
                } // end for each
            } // end list
            .navigationTitle("Requests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 20)))
                }
            }
        }
    }
}


#Preview {
    RequestsView()
        .environmentObject(UserViewModel()) // Inject UserViewModel
        .environmentObject(MembersViewModel()) // Inject MembersViewModel
}
