//
//  MenuItemViewModel.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor
class MenuItemViewModel: ObservableObject {
    @Published var menuItem = MenuItem()
    
    //    func saveMenuItem(menuItem: MenuItem) async -> Bool {
    //        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
    //        if let id = menuItem.id { //menuItem must already exist, so save
    //            do {
    //                try await db.collection("menuItems").document(id).setData(menuItem.dictionary)
    //                print("😎 Data updated successfully!")
    //                return true
    //            } catch {
    //                print("😡 ERROR: Could not update data in 'menuItems' \(error.localizedDescription)")
    //                return false
    //            }
    //        } else { //no id? then this must be a new menuItem to add.
    //            do {
    //                let documentRef = try await db.collection("menuItems").addDocument(data: menuItem.dictionary)
    //                self.menuItem = menuItem
    //                self.menuItem.id = documentRef.documentID
    //                print("🐣 Data created successfully!")
    //                return true
    //            } catch {
    //                print("😡 ERROR: Could not create a new menuItem in 'menuItems' \(error.localizedDescription)")
    //                return false
    //            }
    //        }
    //    }
    
    func saveMenuItem(menuItem: MenuItem) async -> String? {
        let db = Firestore.firestore()
        if let id = menuItem.id { // menuItem must already exist, so save
            do {
                try await db.collection("menuItems").document(id).setData(menuItem.dictionary)
                print("😎 Data updated successfully!")
                return menuItem.id
            } catch {
                print("😡 ERROR: Could not update data in 'menuItems' \(error.localizedDescription)")
                return nil
            }
        } else { // no id? Then this must be a new student to add
            do {
                let docRef = try await db.collection("menuItems").addDocument(data: menuItem.dictionary)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new menuItem in 'menuItems' \(error.localizedDescription)")
                return nil
            }
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
    
//    func saveImage(menuItem: MenuItem, photo: Photo, image: UIImage) async -> Bool {
//        guard let menuItemID = menuItem.id else {
//            print("😡 ERROR: menuItem.id = nil")
//            return false
//        }
//        
//        var photoName = UUID().uuidString // this will be the name of the image file
//        if photo.id != nil {
//            photoName = photo.id! // if i have a photo id, use it as the photoname, this happens when you are updating an existing photo instead of adding a new one. It will resave the photo but its ok since it will just overwrite the existing one.
//        }
//        let storage = Storage.storage() //Create a firebase storage instance
//        let storageRef = storage.reference().child("\(menuItemID)/\(photoName).jpeg")
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
//        //now save to the "photos" collection of the menuItem document "menuItemID"
//        let db = Firestore.firestore()
//        let collectionString = "menuItems/\(menuItemID)/photos"
//        
//        do {
//            var newPhoto = photo
//            newPhoto.imageURLString = imageURLString
//            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
//            print("😎 data updated successfully!")
//            return true
//        } catch {
//            print("😡 ERROR: could not updata data in 'photos' for menuItemID \(menuItemID)")
//            return false
//        }
//    }
}
