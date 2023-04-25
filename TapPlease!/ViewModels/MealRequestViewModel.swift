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
    
//    func saveImage(mealRequest: MealRequest, photo: Photo, image: UIImage) async -> Bool {
//        guard let mealRequestID = mealRequest.id else {
//            print("😡 ERROR: mealRequest.id = nil")
//            return false
//        }
//        
//        var photoName = UUID().uuidString // this will be the name of the image file
//        if photo.id != nil {
//            photoName = photo.id! // if i have a photo id, use it as the photoname, this happens when you are updating an existing photo instead of adding a new one. It will resave the photo but its ok since it will just overwrite the existing one.
//        }
//        let storage = Storage.storage() //Create a firebase storage instance
//        let storageRef = storage.reference().child("\(mealRequestID)/\(photoName).jpeg")
//        
//        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
//            print("😡 ERROR: could not resize image")
//            return false
//        }
//        
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg" //setting mettadata allows you to see the console image in the web browser. This setting will work fo jpeg and png
//        
//        var imageURLString = ""
//        
//        do {
//            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
//            print("📸 image saved!")
//            do {
//                let imageURL = try await storageRef.downloadURL()
//                imageURLString = "\(imageURL)" // we will save this string to cloud firestore as part of document in Photos collection below
//            } catch {
//                print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
//                return false
//            }
//        } catch {
//            print("😡 ERROR: uploading image to FirebaseStorage")
//            return false
//
//        }
//        
//        //now save to the "photos" collection of the mealRequest document "mealRequestID"
//        let db = Firestore.firestore()
//        let collectionString = "mealRequests/\(mealRequestID)/photos"
//        
//        do {
//            var newPhoto = photo
//            newPhoto.imageURLString = imageURLString
//            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
//            print("😎 data updated successfully!")
//            return true
//        } catch {
//            print("😡 ERROR: could not updata data in 'photos' for mealRequestID \(mealRequestID)")
//            return false
//        }
//    }
}
