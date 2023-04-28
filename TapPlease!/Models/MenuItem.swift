//
//  MenuItem.swift
//  TapPlease!
//
//  Created by George Sigety on 4/25/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct MenuItem: Identifiable, Codable {
    @DocumentID var id: String?
    var description = ""
    var imageID = ""
    var name = ""
    var postedBy = Auth.auth().currentUser?.uid ?? ""

    var dictionary: [String: Any] {
        return ["description": description, "imageID": imageID, "name": name, "postedBy": postedBy]
    }
}
