//
//  MealRequestDetailView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import PhotosUI


struct MealRequestDetailView: View {
    
    @EnvironmentObject var mealRequestVM: MealRequestViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @Environment (\.dismiss) private var dismiss
    @State var mealRequest: MealRequest
    @State private var postedByThisUser = false
    @State private var showingAsSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if !showingAsSheet {
                Text("Posted By: \(mealRequest.postedByName)")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
            }
            Text("Desired Meal:")
                .font(.title)
                .bold()
            TextField("enter what you want", text: $mealRequest.menuItem)
                .textFieldStyle(.roundedBorder)
            
            Text("Delivery Location:")
                .font(.title)
                .bold()
            TextField("enter delivery location", text: $mealRequest.pickupLocation)
                .textFieldStyle(.roundedBorder)
            Text("Notes:")
                .font(.title)
                .bold()
            TextField("enter notes", text: $mealRequest.notes)
                .textFieldStyle(.roundedBorder)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            Text("Expires at: \((mealRequest.postedOn + 3600).formatted(date: .omitted, time: .shortened))")
                .font(.title)

        }
        .disabled(!postedByThisUser) //disable if review not posed by this user
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .task {
            try? await profileVM.loadCurrentUser()
        }
        .onAppear {
            if  mealRequest.id == nil {
                showingAsSheet = true
            }
            if mealRequest.postedBy == Auth.auth().currentUser?.uid {
                postedByThisUser = true
            }
        }
        .toolbar {
            if postedByThisUser { //new mealRequest, show Cancel / Save buttons
                if showingAsSheet {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        mealRequest.postedByName = profileVM.user?.name ?? ""
                        Task {
                            let success = await mealRequestVM.saveMealRequest(mealRequest: mealRequest)
                            if success {
                                dismiss()
                            } else {
                                print("😡 DANG! Error saving mealRequest!")
                            }
                        }
                        dismiss()
                    }
                }
                if mealRequest.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task {
                                let success = await mealRequestVM.deleteMealRequest(mealRequest: mealRequest)
                                if success {
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
    }
}

struct MealRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealRequestDetailView(mealRequest: MealRequest(menuItem: "Chichen Tikka", pickupLocation: "Walsh Hall 202", notes: "please knock on the door when you get here!"))
    }
}
