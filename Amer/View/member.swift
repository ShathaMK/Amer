//
//  member.swift
//  Amer
//
//  Created by shaden on 29/06/1446 AH.
//

import SwiftUI

struct MembersView: View {
    @State private var search: String = ""
    @State private var contacts: [Contact] = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210"),
        Contact(name: "Alice Johnson", phoneNumber: "555-1234"),
        Contact(name: "Bob Brown", phoneNumber: "555-5678")
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
        VStack {
            // Search Bar with Request Button
            HStack {
                TextField("Search Contacts", text: $search)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.leading)
                
                Button(action: {
                    // Action for request button
                    print("Request button tapped")
                }) {
                    Text("Request")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .padding(.top)
            
            //send invitation
            
            Button{
                
            }label: {
                HStack{
                    Text("Send Invitation")
                        .padding()
                    Spacer()
                    //Image
                }
            }
            .padding(.top,40)
            // Contacts List
            ScrollView {
                LazyVStack {
                    ForEach(filteredContacts) { contact in
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
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

                            Button(action: {
                                print("More options for \(contact.name)")
                            }) {
                                Image(systemName: "ellipsis.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding()

                }
        .navigationTitle("Contacts")
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
