//
//  Message.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var text = ""
    var timestamp = Date()
    var sender = Auth.auth().currentUser?.uid ?? ""
    
    var dictionary: [String: Any] {
        return ["text": text, "timestamp": Timestamp(date: Date()), "sender": sender]
    }
}
