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
    @State private var photo = Photo()
    
    var searchResult: [MealRequest] {
        if searchText.isEmpty {
            return mealRequests
        } else {
            return mealRequests.filter {$0.pickupLocation.capitalized.contains(searchText)}
        }
    }
    var body: some View {
        NavigationStack {
            List(mealRequests) { mealRequest in
                NavigationLink {
                    MealRequestDetailView(mealRequest: mealRequest)
                } label: {
                    HStack {
                        Text(mealRequest.pickupLocation)
                        Spacer()
                        if mealRequest.postedBy != Auth.auth().currentUser?.email {
                            Button("Accept") {
                                Task {
                                    await messengerVM.saveMessenger(messenger: Messenger(reciever: mealRequest.postedBy))
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }
            }
            .listStyle(.plain)
            .font(.title2)
            .navigationTitle("Meal Requests")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .onAppear {
                let now = Date()
                for mealRequest in mealRequests {
                    if mealRequest.postedOn + 3600 < now {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
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
