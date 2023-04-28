//
//  Messenger.swift
//  TapPlease!
//
//  Created by George Sigety on 4/25/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Messenger: Identifiable, Codable {
    @DocumentID var id: String?
    var reciever = ""
    var recieverName = ""
    var senderName = ""
    var sender = Auth.auth().currentUser?.uid ?? ""
    var created = Date()
    var mealRequestID = ""

    var dictionary: [String: Any] {
        return ["reciever": reciever, "recieverName": recieverName, "senderName": senderName, "sender": sender, "created": Timestamp(date: Date()), "mealRequestID": mealRequestID]
    }
}

