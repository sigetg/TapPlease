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
        } else { // no id? Then this must be a new menuItem to add
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
    
//    func getImageURL(id: String) async -> URL? {
//        let storage = Storage.storage()
//        let storageRef = storage.reference().child("\(id)/image.jpg")
//
//        do {
//            let url = try await storageRef.downloadURL()
//            return url
//        } catch {
//            return nil
//        }
//    }

//    func saveImage(id: String, image: UIImage) async {
//        let storage = Storage.storage()
//        let storageRef = storage.reference().child("\(id)/image.jpg")
//
//        let resizedImage = image.jpegData(compressionQuality: 0.2)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpg"
//
//        if let resizedImage = resizedImage {
//            do {
//                let metadata = try await storageRef.putDataAsync(resizedImage)
//                print("Metadata: ", metadata)
//                print("📸 Image Saved!")
//            } catch {
//                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
//            }
//        }
//    }
    
    
//    func saveImage(id: String, photo: Photo, image: UIImage) async {
//
//        var photoName = UUID().uuidString // this will be the name of the image file
//        if photo.id != nil {
//            photoName = photo.id! // if i have a photo id, use it as the photoname, this happens when you are updating an existing photo instead of adding a new one. It will resave the photo but its ok since it will just overwrite the existing one.
//        }
//        let storage = Storage.storage() //Create a firebase storage instance
//        let storageRef = storage.reference().child("\(id)/\(photoName).jpeg")
//
//        let resizedImage = image.jpegData(compressionQuality: 0.2)
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg" //setting mettadata allows you to see the console image in the web browser. This setting will work fo jpeg and png
//
//        var imageURLString = ""
//
//        if let resizedImage = resizedImage {
//            do {
//                let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
//                print("📸 image saved!")
//                do {
//                    let imageURL = try await storageRef.downloadURL()
//                    imageURLString = "\(imageURL)" // we will save this string to cloud firestore as part of document in Photos collection below
//                } catch {
//                    print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
//                    return
//                }
//
//            } catch {
//                print("😡 ERROR: uploading image to FirebaseStorage")
//                return
//
//            }
//        }
//        //now save to the "photos" collection of the menuItem document "menuItemID"
//        let db = Firestore.firestore()
//        let collectionString = "menuItems/\(id)/photos"
//
//        do {
//            var newPhoto = photo
//            newPhoto.imageURLString = imageURLString
//            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
//            print("😎 data updated successfully!")
//        } catch {
//            print("😡 ERROR: could not updata data in 'photos' for menuItemID \(id)")
//        }
//    }
//
//    func getPhotos(id: String) async {
//        let db = Firestore.firestore() //ignore any error that shows up here. Wait for indexing. Clean build if it persists with Shift+Command+K.
//        do {
//            let refArray = try await db.collection("menuItems").document(id).collection("photos").getDocuments()
//            print("😎 photos Found!")
//            do {
//                for document in refArray.documents {
//                    let data = try document.data(as: Photo.self)
//                    photos.append(data)
//                }
//                print("data successfully converted")
//                return
//            } catch {
//                print("😡 ERROR: Could not convert data to Photo: \(error.localizedDescription)")
//            }
//        } catch {
//            print("😡 ERROR: Could not get data in 'photos': \(error.localizedDescription)")
//            return
//        }
//        return
//    }
}
