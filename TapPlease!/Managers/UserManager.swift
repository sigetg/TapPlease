//
//  UserManager.swift
//  TapPlease!
//
//  Created by George Sigety on 4/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
        
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path ?? "",
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url ?? "",
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserName(userId: String, name: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.name.rawValue : name ?? ""
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
}

