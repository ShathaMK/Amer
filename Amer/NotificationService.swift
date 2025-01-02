//  NotificationService.swift
//  Amer
//
//  Created by Shatha Almukhaild on 02/07/1446 AH.
//


import UserNotifications
import CloudKit
class NotificationService {
    static let shared = NotificationService()
    
    private init() {}

    func sendNotificationToAssistant(assistantRecordID: CKRecord.ID) {
        // Fetch the assistant's device token using their record ID
        fetchAssistantDeviceToken(recordID: assistantRecordID) { deviceToken in
            if let deviceToken = deviceToken {
                // Send the push notification using the device token
                self.sendPushNotification(toDeviceToken: deviceToken, message: "You have a new task!")
            } else {
                print("Failed to fetch assistant's device token")
            }
        }
    }



    func fetchAssistantDeviceToken(recordID: CKRecord.ID, completion: @escaping (String?) -> Void) {
        let database = CKContainer.default().publicCloudDatabase
        
        database.fetch(withRecordID: recordID) { (record, error) in
            if let record = record {
                print("Assistant's record: \(record)")

                let deviceToken = record["deviceToken"] as? String
                completion(deviceToken)
            } else {
                print("Error fetching assistant's device token: \(String(describing: error))")
                completion(nil)
            }
        }
    }



    func sendPushNotification(toDeviceToken deviceToken: String, message: String) {
        // Create a local notification for testing purposes
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Immediate delivery
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification sent to device token: \(deviceToken)")
            }
        }
    }



}
