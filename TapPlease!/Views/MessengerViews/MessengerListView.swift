//
//  MessageListView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MessengerListView: View {
    @EnvironmentObject var messengerVM: MessengerViewModel
    @EnvironmentObject var mealRequestVM: MealRequestViewModel
    @FirestoreQuery(collectionPath: "messengers") var messengers: [Messenger]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var myMessengers: [Messenger] {
    var tempMessengers: [Messenger] = []
        for messenger in messengers {
            if messenger.reciever == Auth.auth().currentUser?.uid || messenger.sender == Auth.auth().currentUser?.uid {
                tempMessengers.append(messenger)
            }
        }
        return tempMessengers
    }
    
    var body: some View {
        NavigationStack {
            List(myMessengers) { messenger in
                NavigationLink {
                    MessengerDetailView(messenger: messenger)
                } label: {
                    Text(messenger.reciever == Auth.auth().currentUser?.uid ? messenger.senderName : messenger.recieverName)
                }
            }
            .listStyle(.plain)
            .font(.title2)
            .navigationTitle("Active Request Chats")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
    }
}

struct MessengerListView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerListView()
    }
}
