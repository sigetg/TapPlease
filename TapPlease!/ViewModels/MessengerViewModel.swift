//
//  MessengerViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor
class MessengerViewModel: ObservableObject {
    @Published var messenger = Messenger()
    
    func saveMessenger(messenger: Messenger) async -> Bool {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        if let id = messenger.id { //messenger must already exist, so save
            do {
                try await db.collection("messengers").document(id).setData(messenger.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'messengers' \(error.localizedDescription)")
                return false
            }
        } else { //no id? then this must be a new messenger to add.
            do {
                let documentRef = try await db.collection("messengers").addDocument(data: messenger.dictionary)
                self.messenger = messenger
                self.messenger.id = documentRef.documentID
                print("🐣 Data created successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new messenger in 'messengers' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func getMealRequest(messenger: Messenger) async -> MealRequest? {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        do {
            let ref = try await db.collection("mealRequests").document(messenger.mealRequestID).getDocument()
            print("😎 Meal Request Found!")
            do {
                let data = try ref.data(as: MealRequest.self)
                print("data successfully converted")
                return data
            } catch {
                print("😡 ERROR: Could not convert data to MealRequest: \(error.localizedDescription)")
            }
        } catch {
            print("😡 ERROR: Could not update data in 'messengers': \(error.localizedDescription)")
            return nil
        }
        return nil
    }
}
