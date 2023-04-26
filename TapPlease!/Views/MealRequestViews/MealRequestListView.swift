//
//  MealRequestListView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MealRequestListView: View {
    @EnvironmentObject var mealRequestVM: MealRequestViewModel
    @EnvironmentObject var messengerVM: MessengerViewModel
    @FirestoreQuery(collectionPath: "mealRequests") var mealRequests: [MealRequest]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var sheetIsPresented = false
    @State private var uiImage = UIImage()
    //    @State private var photo = Photo()
    @State var messenger = Messenger()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(mealRequests.filter{ !$0.accepted }) { mealRequest in
                    NavigationLink {
                        MealRequestDetailView(mealRequest: mealRequest)
                    } label: {
                        HStack {
                            Text(mealRequest.pickupLocation)
                            Spacer()
                            if mealRequest.postedBy != Auth.auth().currentUser?.email {
                                Button("accept") {
                                    var newMealRequest = mealRequest
                                    newMealRequest.accepted = true
                                    Task {
                                        var success = await mealRequestVM.deleteMealRequest(mealRequest: mealRequest)
                                        success = await messengerVM.saveMessenger(messenger: Messenger(reciever: newMealRequest.postedBy, mealRequestID: newMealRequest.id ?? ""))
                                        success = await mealRequestVM.saveMealRequest(mealRequest: newMealRequest)
                                        if success {
                                            print("Meal Request Accepted")
                                        }
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding()
                    }
                }
                Button {
                    sheetIsPresented.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .padding(.bottom)
            }
            .listStyle(.plain)
            .font(.title2)
            .navigationTitle("Meal Requests")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let now = Date()
                for mealRequest in mealRequests {
                    if mealRequest.postedOn + 3600 < now && mealRequest.accepted == false {
                        Task {
                            await mealRequestVM.deleteMealRequest(mealRequest: mealRequest)
                        }
                    }
                }
            }
            .refreshable {
                let now = Date()
                for mealRequest in mealRequests {
                    if mealRequest.postedOn + 3600 < now {
                        Task {
                            await mealRequestVM.deleteMealRequest(mealRequest: mealRequest)
                        }
                    }
                }
            }
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
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                MealRequestDetailView(mealRequest: MealRequest())
            }
        }
    }
}

struct MealRequestListView_Previews: PreviewProvider {
    static var previews: some View {
        MealRequestListView()
    }
}
