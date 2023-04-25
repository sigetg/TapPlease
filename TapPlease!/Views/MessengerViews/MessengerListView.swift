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
    @FirestoreQuery(collectionPath: "messengers") var messengers: [Messenger]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var myMessengers: [Messenger] {
    var tempMessengers: [Messenger] = []
        for messenger in messengers {
            if messenger.reciever == Auth.auth().currentUser?.email || messenger.sender == Auth.auth().currentUser?.email {
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
                    Text(messenger.reciever == Auth.auth().currentUser?.email ? messenger.sender : messenger.reciever)
                }
            }
            .listStyle(.plain)
            .font(.title2)
            .navigationTitle("Active Request Chats")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out Successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                    }
                }
            }
        }
    }
}

struct MessengerListView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerListView()
    }
}
