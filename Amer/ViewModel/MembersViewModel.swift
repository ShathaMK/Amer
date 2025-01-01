//
//  Untitled.swift
//  Amer
//
//  Created by shaden on 01/07/1446 AH.
//

import Foundation
import SwiftUI

class MembersViewModel: ObservableObject {
    @Published var contacts: [Contact] = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210"),
        Contact(name: "Ali Johnson", phoneNumber: "555-1234"),
        Contact(name: "Shaden", phoneNumber: "555-5678")
    ]
    
    @Published var requests: [Member] = [
        Member(name: "John Doe", phone: "+96658989870"),
        Member(name: "Jane Smith", phone: "+96658989870")
    ]
    
    @Published var members: [Member] = [
        Member(name: "Alice Johnson", phone: "+96658989870"),
        Member(name: "Bob Brown", phone: "+96658989870")
    ]
    
    // Generate invitation URL based on member's role
    func generateInvitationLink(for member: Member) -> String {
        // Assuming we have two roles: sender and receiver
        let role = member.phone == "+96658989870" ? "receiver" : "sender"
        let encodedName = member.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? member.name
        return "myapp://signup?role=\(role)&name=\(encodedName)"
    }
    
    // Handle the invitation link when opened (deep link)
    func handleDeepLink(_ url: URL) {
        // Example of handling deep link (if needed)
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let role = components.queryItems?.first(where: { $0.name == "role" })?.value {
            print("Received deep link with role: \(role)")
            // Depending on the role, navigate to the corresponding sign-up flow
        }
    }
    
    // Filtered contacts based on search query
    func filteredContacts(searchQuery: String) -> [Contact] {
        if searchQuery.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    // Delete contact action
    func deleteContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts.remove(at: index)
        }
    }
    
    // Delete contact by index (for list swipe action)
    func deleteContactAtIndex(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}
