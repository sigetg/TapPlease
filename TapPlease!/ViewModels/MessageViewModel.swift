//
//  MessageViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class MessageViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published var message = Message()
    @Published private(set) var lastMessageId: String = ""
    
    // Create an instance of our Firestore database
    let db = Firestore.firestore()
    
    // Read message from Firestore in real-time with the addSnapShotListener
    func getMessages(messenger: Messenger, messages: [Message]) {
        
        guard let messengerID = messenger.id else {
            print("😡 ERROR: messenger.id = nil")
            return
        }
        let collectionString = "messengers/\(messengerID)/messages"
        
        db.collection(collectionString).addSnapshotListener { querySnapshot, error in
            
            // If we don't have documents, exit the function
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            // Mapping through the documents
            self.messages = documents.compactMap { document -> Message? in
                do {
                    // Converting each document into the Message model
                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
                    return try document.data(as: Message.self)
                } catch {
                    // If we run into an error, print the error in the console
                    print("Error decoding document into Message: \(error)")
                    
                    // Return nil if we run into an error - but the compactMap will not include it in the final array
                    return nil
                }
            }
            
            // Sorting the messages by sent date
            self.messages.sort { $0.timestamp < $1.timestamp }
            
            // Getting the ID of the last message so we automatically scroll to it in ContentView
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    // Add a message in Firestore    
    func sendMessage(messenger: Messenger, message: Message) async {
        guard let messengerID = messenger.id else {
            print("😡 ERROR: messenger.id = nil")
            return
        }
        let collectionString = "messengers/\(messengerID)/messages"
        
        do {
            let documentRef = try await db.collection(collectionString).addDocument(data: message.dictionary)
            self.message = message
            self.message.id = documentRef.documentID
            print("🐣 Data created successfully!")
            return
        } catch {
            print("😡 ERROR: Could not create a new messenger in 'messengers' \(error.localizedDescription)")
            return
        }
    }
    
    func addMessageNotification(message: Message) { //TODO: Somehow add messege notifiations by detecting when a message from a given user sends a message
        let content = UNMutableNotificationContent()
        content.title = "Tap Please!"
        content.subtitle = message.text
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
