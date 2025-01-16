//
//  MembersView.swift
//  Amer
//
//  Created by shaden on 29/06/1446 AH.
//

import SwiftUI

struct MembersView: View {
//    @StateObject var memberVM = MembersViewModel()
//    @StateObject var userVM = UserViewModel()
    
    @EnvironmentObject var memberVM: MembersViewModel
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    @EnvironmentObject var userVM: UserViewModel

    @State var showRequestsSheet = false
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the view

    var body: some View {
        NavigationStack {
            VStack(spacing: userVM.scaledFont(baseSize: 16)) {
                // Search Bar and Requests Button
                HStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $memberVM.search)
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    Button(action: {
                        showRequestsSheet.toggle()
                        userVM.triggerHapticFeedback() // Haptic feedback
                    }) {
                        ZStack {
                            Text("Requests")
                                .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .background(Color("ColorGreen"))
                                .cornerRadius(10)

                            if !memberVM.requests.isEmpty {
                                Text("\(memberVM.requests.count)")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color("DarkBlue"))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .offset(x: 40, y: -20)
                            }
                        }
                    }
                    .sheet(isPresented: $showRequestsSheet) {
                        RequestsView()
                            .presentationDetents([.fraction(0.5), .large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .padding(.horizontal)

                // Add Members Button
                ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui")!) {
                    HStack {
                        Text("Add Members")
                            .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("ColorGreen"))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
                    .frame(height: userVM.scaledFont(baseSize: 16))
                
                // Members List
                List {
                    ForEach(memberVM.filteredContacts) { contact in
                        HStack(spacing: userVM.scaledFont(baseSize: 16)) {
                            Image("User_Assistant")
                                .resizable()
                                .foregroundColor(Color.blue)
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.name)
                                    .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 16)))
                                    .foregroundColor(Color("DarkBlue"))
                                Text(contact.phoneNumber)
                                    .font(.custom("Tajawal-Regular", size: userVM.scaledFont(baseSize: 14)))
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                userVM.triggerHapticFeedback() // Haptic feedback
                                memberVM.deleteMemberFromCloud(contact: contact) { success in
                                    if success {
                                        print("Member deleted successfully.")
                                    } else {
                                        print("Error deleting member.")
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: memberVM.deleteContactFromIndex)
                }
                .listStyle(PlainListStyle())
                
            }
            .padding(.top)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        userVM.triggerHapticFeedback() // Haptic feedback
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25.5)
                            .foregroundStyle(Color("FontColor"))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Members")
                        .foregroundColor(Color("FontColor"))
                        .font(.custom("Tajawal-Bold", size: userVM.scaledFont(baseSize: 30)))
                }
            }
        }
    }
}

#Preview {
    MembersView()
        .environmentObject(ButtonsViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(MembersViewModel())
        
}
