//
//  ReviewViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    @Published var reviews: [Review] = []
    

    
    
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
    
    func getReviews(id: String) async {
        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
        do {
            let refArray = try await db.collection("menuItems").document(id).collection("reviews").getDocuments()
            print("😎 reviews Found!")
            do {
                for document in refArray.documents {
                    let data = try document.data(as: Review.self)
                    reviews.append(data)
                }
                print("data successfully converted")
                return
            } catch {
                print("😡 ERROR: Could not convert data to Review: \(error.localizedDescription)")
            }
        } catch {
            print("😡 ERROR: Could not get data in 'reviews': \(error.localizedDescription)")
            return
        }
        return
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")

        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            return nil
        }
    }

    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")

        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        if let resizedImage = resizedImage {
            do {
                let metadata = try await storageRef.putDataAsync(resizedImage)
                print("Metadata: ", metadata)
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
            }
        }
    }
}
