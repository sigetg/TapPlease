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
    @EnvironmentObject var profileVM: ProfileViewModel
    @State var messenger: Messenger
    @State var mealRequest = MealRequest()
    
    var body: some View {
        HStack(spacing: 20) {
            if let urlString = profileVM.user?.photoUrl, let url = URL(string: urlString) {
                
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
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
            try? await profileVM.loadCurrentUser()
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
