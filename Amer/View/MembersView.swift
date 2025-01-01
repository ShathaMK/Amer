//
//  member.swift
//  Amer
//
//  Created by shaden on 29/06/1446 AH.
//

import SwiftUI

struct MembersView: View {
    
    
    @State private var showRequestsSheet = false
    @State private var requests = [
        Member(name: "John Doe", phone: "+96658989870"),
        Member(name: "Jane Smith", phone: "+96658989870")
    ]
    @State private var members = [
        Member(name: "Alice Johnson", phone: "+96658989870"),
        Member(name: "Bob Brown", phone: "+96658989870")
    ]
    
    @State private var search: String = ""
    
    @State private var contacts: [Contact] = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210"),
        Contact(name: "Ali Johnson", phoneNumber: "555-1234"),
        Contact(name: "Shaden", phoneNumber: "555-5678")
    ]
    
    // Sample contact model
    struct Contact: Identifiable {
        var id = UUID()
        var name: String
        var phoneNumber: String
    }
    
    var filteredContacts: [Contact] {
        if search.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(search.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack(){
            
            
            VStack {
                // Search Bar with Request Button
                HStack {
                    TextField("Search", text: $search)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(60)

                    
                    // Show Requests Button
                    Button(action: {
                        showRequestsSheet.toggle()
                    }) {
                        
                        ZStack(){
                            
                            Text("Requests")
                                .padding()
                                .font(.custom("Tajawal-Bold", size: 20))
                                .foregroundColor(.white)
                                .background(Color("ColorGreen"))
                                .cornerRadius(10)
                            
                            Text("\(requests.count)")
                                .padding(8)
                                .background(Color("DarkBlue"))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding(.bottom, 35)
                                .padding(.leading, 100)
                        }
                    } // end button
                    .sheet(isPresented: $showRequestsSheet) {
                        // Show the requests sheet here
                        RequestsView(requests: $requests, members: $members)
                            .presentationDetents([.fraction(0.5), .large])
                            .presentationDragIndicator(.visible)
                    }
                    
                
                }
                Spacer()
                
                // Send Invitation Button
                VStack {
                    ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui")!) {
                        HStack {
                            Text("Send Invitation")
                                .font(.custom("Tajawal-Bold", size: 20))
                                .shadow(radius: 7, x: 0, y: 5)
                            
                            Spacer()
                            
                            Image(systemName: "square.and.arrow.up")
                        }
                        .padding()
                    }
                    .buttonStyle(GreenButton())
                }
                .padding(.top, 40)
                
                //MARK: Contacts List with Swipe Actions
                
                List {
                    ForEach(filteredContacts) { contact in
                        HStack {
                            Image("Assistant_user")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        // Adding swipe actions here
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Delete contact action
                                deleteContact(contact)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteContactFromIndex)
                } //MARK: contacts list with Swipe Actions
                .listStyle(PlainListStyle()) // Optional: makes the list style clean
                
                
            }
            .navigationTitle("Members")
            
            
        }
        
    }
    
    
    
    
    struct RequestsView: View {
        @Environment(\.dismiss) var dismiss
        
        @Binding var requests: [Member]
        @Binding var members: [Member]
        
        var body: some View {
            NavigationView {
                VStack {
                    
                    
                    List {
                        ForEach(requests) { request in
                            HStack {
                                //Circle()
                                Image("Assistant_user")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                //.foregroundColor(.blue)
                                
                                //.frame(width: 40, height: 40)
                                VStack(alignment: .leading) {
                                    Text(request.name)
                                        .font(.headline)
                                    Text(request.phone)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    addMember(request)
                                }) {
                                    Button("Add") {
                                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                                    }
                                    .font(.custom("Tajawal-Medium", size: 20))
                                    .buttonStyle(GreenButton())
                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                   Image(systemName: "person.badge.plus")
                                    
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(.horizontal, 10)
                                
                                Button(action: {
                                    deleteRequest(request)
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.black)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                .navigationTitle("Requests")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            dismiss()
                        }
                        .font(.custom("Tajawal-Bold", size: 20))
                        
                    }
                }
            }
        }
        
        // Add Member Action
        func addMember(_ request: Member) {
            members.append(request)
            requests.removeAll { $0.id == request.id }
        }
        
        // Delete Request Action
        func deleteRequest(_ request: Member) {
            requests.removeAll { $0.id == request.id }
        }
        
        
    }
    
    
    
    
    
    // Function to delete a contact
    func deleteContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts.remove(at: index)
        }
    }

    // Function to delete by index (required by `onDelete`)
    func deleteContactFromIndex(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
    
    
    
}





struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}






   

    
    

