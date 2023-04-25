//
//  ReviewViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(menuItem: MenuItem, review: Review) async -> Bool {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        
        guard let menuItemID = menuItem.id else {
            print("😡 ERROR: menuItem.id = nil")
            return false
        }
        
        let collectionString = "menuItems/\(menuItemID)/reviews"
        
        if let id = review.id { //review must already exist, so save
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else { //no id? then this must be a new review to add.
            do {
                _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("🐣 Data created successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false

            }
        }
    }
    
    func deleteReview(menuItem: MenuItem, review: Review) async -> Bool {
        let db = Firestore.firestore()
        guard let menuItemID = menuItem.id, let reviewID = review.id else {
            print("😡 ERROR: menuItem.id = \(menuItem.id ?? "nil"), review.id = \(review.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("menuItems").document(menuItemID).collection("reviews").document(reviewID).delete()
            print("🗑️ document successfully deleted!")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
}
