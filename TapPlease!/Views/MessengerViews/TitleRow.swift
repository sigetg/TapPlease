//
//  TitleRow.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TitleRow: View {
    @EnvironmentObject var messengerVM: MessengerViewModel
    @State var messenger: Messenger
    @State var mealRequest = MealRequest()
    var imageUrl = URL(string: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8")
    
    var body: some View { //TODO: add emergency button, info to make functionality clear
        HStack(spacing: 20) {
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(messenger.reciever == Auth.auth().currentUser?.email ? messenger.sender : messenger.reciever)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .bold()
                    .font(.title)
                HStack {
                    Text("Pickup Location:")
                        .bold()
                    Spacer()
                    Text(mealRequest.pickupLocation)
                }
                HStack {
                    Text("Desired Meal:")
                        .bold()
                    Spacer()
                    Text(mealRequest.menuItem)
                }
                HStack {
                    Text("Notes:")
                        .bold()
                    Spacer()
                    Text(mealRequest.notes)
                }
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .task {
            if await messengerVM.getMealRequest(messenger: messenger) == nil {
                print("could not get mealRequest. returned nil")
            } else {
                mealRequest = await messengerVM.getMealRequest(messenger: messenger)!
            }
        }
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(messenger: Messenger())
            .background(Color("Peach"))
    }
}
