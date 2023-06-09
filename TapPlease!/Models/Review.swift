//
//  Review.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var imageID = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating, "imageID": imageID, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}
