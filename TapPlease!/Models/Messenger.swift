//
//  Messenger.swift
//  TapPlease!
//
//  Created by George Sigety on 4/25/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Messenger: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var reciever = ""
    var sender = Auth.auth().currentUser?.email ?? ""
    
    var dictionary: [String: Any] {
        return ["reciever": reciever, "sender": sender]
    }
}

