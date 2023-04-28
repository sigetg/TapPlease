//
//  MealRequest.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct MealRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var menuItem = ""
    var pickupLocation = ""
    var notes = ""
    var postedBy = Auth.auth().currentUser?.uid ?? ""
    var postedByName = ""
    var postedOn = Date()
    var accepted = false

    var dictionary: [String: Any] {
        return ["menuItem": menuItem, "pickupLocation": pickupLocation, "notes": notes, "postedBy": postedBy, "postedByName": postedByName, "postedOn": Timestamp(date: Date()), "accepted": accepted]
    }
}
