//
//  MealRequestViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor
class MealRequestViewModel: ObservableObject {
    @Published var mealRequest = MealRequest()
    
    func saveMealRequest(mealRequest: MealRequest) async -> Bool {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        if let id = mealRequest.id { //mealRequest must already exist, so save
            do {
                try await db.collection("mealRequests").document(id).setData(mealRequest.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'mealRequests' \(error.localizedDescription)")
                return false
            }
        } else { //no id? then this must be a new mealRequest to add.
            do {
                let documentRef = try await db.collection("mealRequests").addDocument(data: mealRequest.dictionary)
                self.mealRequest = mealRequest
                self.mealRequest.id = documentRef.documentID
                print("🐣 Data created successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new mealRequest in 'mealRequests' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func getMealRequest(id: String) async -> MealRequest? {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        do {
            let ref = try await db.collection("mealRequests").document(id).getDocument()
            print("😎 Meal Request Found!")
            do {
                let data = try ref.data(as: MealRequest.self)
                print("data successfully converted")
                return data
            } catch {
                print("😡 ERROR: Could not convert data to MealRequest: \(error.localizedDescription)")
            }
        } catch {
            print("😡 ERROR: Could not update data in 'mealRequests': \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    func deleteMealRequest(mealRequest: MealRequest) async -> Bool {
        let db = Firestore.firestore()
        guard let mealRequestID = mealRequest.id else {
            print("😡 ERROR: mealRequest.id = \(mealRequest.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("mealRequests").document(mealRequestID).delete()
            print("🗑️ document successfully deleted!")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
}
