//
//  DBUser.swift
//  TapPlease!
//
//  Created by George Sigety on 4/28/23.
//

import Foundation


struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let name: String?
    let tapperLevel: String?
    let profileImagePath: String?
    let profileImagePathUrl: String?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.name = nil
        self.tapperLevel = "1"
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        name: String? = nil,
        tapperLevel: String? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.name = name
        self.tapperLevel = name
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case name = "name"
        case tapperLevel = "tapperLevel"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
}
