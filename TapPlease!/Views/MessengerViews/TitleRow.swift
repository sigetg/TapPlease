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
    @EnvironmentObject var mealRequestVM: MealRequestViewModel
    @State var messenger: Messenger
    @State var mealRequest = MealRequest()
    
    var body: some View {
        HStack(spacing: 20) {
//            AsyncImage(url: url) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(50)
//            } placeholder: {
//                ProgressView()
//                    .frame(width: 50, height: 50)
//            }
            VStack(alignment: .leading) {
                Text(messenger.reciever == Auth.auth().currentUser?.uid ? messenger.senderName : messenger.recieverName)
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
            if await mealRequestVM.getMealRequest(id: messenger.mealRequestID) == nil {
                print("could not get mealRequest. returned nil")
            } else {
                mealRequest = await mealRequestVM.getMealRequest(id: messenger.mealRequestID)!
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
