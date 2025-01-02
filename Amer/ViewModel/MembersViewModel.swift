//
//  SwiftUIView.swift
//  Amer
//
//  Created by Noori on 02/01/2025.
//

import Foundation
import SwiftUI
import CloudKit

class MembersViewModel: ObservableObject {
    @Published var requests: [Member] = [
        Member(name: "John Doe", phone: "+96658989870"),
        Member(name: "Jane Smith", phone: "+96658989870")
    ]
    @Published var members: [Member] = [
        Member(name: "Alice Johnson", phone: "+96658989870"),
        Member(name: "Bob Brown", phone: "+96658989870")
    ]
    @Published var contacts: [Contact] = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210"),
        Contact(name: "Ali Johnson", phoneNumber: "555-1234"),
        Contact(name: "Shaden", phoneNumber: "555-5678")
    ]
    @Published var search: String = ""
    @Published var errorMessage: String?

    private let database = CKContainer.default().publicCloudDatabase

    var filteredContacts: [Contact] {
        if search.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(search.lowercased()) }
        }
    }

    func addMember(_ request: Member) {
        members.append(request)
        requests.removeAll { $0.id == request.id }
    }

    func deleteRequest(_ request: Member) {
        requests.removeAll { $0.id == request.id }
    }

    func deleteContact(_ contact: Contact) {
        contacts.removeAll { $0.id == contact.id }
    }

    func deleteContactFromIndex(at offsets: IndexSet) {
        offsets.forEach { index in
            let contact = contacts[index]
            deleteMemberFromCloud(contact: contact) { success in
                if success {
                    print("Contact deleted successfully.")
                } else {
                    print("Failed to delete contact.")
                }
            }
        }
    }

    // Delete a member from CloudKit
    func deleteMemberFromCloud(contact: Contact, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "userId_2.phoneNumber == %@", contact.phoneNumber)
        let query = CKQuery(recordType: "Members", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error fetching member: \(error.localizedDescription)"
                    completion(false)
                }
                return
            }

            guard let record = records?.first else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Member not found in CloudKit."
                    completion(false)
                }
                return
            }

            self?.database.delete(withRecordID: record.recordID) { _, deleteError in
                if let deleteError = deleteError {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error deleting member: \(deleteError.localizedDescription)"
                        completion(false)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.contacts.removeAll { $0.phoneNumber == contact.phoneNumber }
                        completion(true)
                    }
                }
            }
        }
    }
}
