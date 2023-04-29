//
//  MenuItemDetailView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MenuItemDetailView: View {
    
    @EnvironmentObject var menuItemVM: MenuItemViewModel
    @EnvironmentObject var reviewsVM: ReviewViewModel
    @Environment (\.dismiss) private var dismiss
    @State var menuItem: MenuItem
    @State private var showingAsSheet = false
    @State private var showSaveAlert = false
    @State private var showReviewViewSheet = false
    @State var avgVal = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                Text("Menu Item:")
                    .bold()
                TextField("enter food", text: $menuItem.name)
                    .textFieldStyle(.roundedBorder)
                Text("Description:")
                    .bold()
                TextField("enter description:", text: $menuItem.description, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            HStack {
                Group {
                    Text("Avg. Rating:")
                        .font(.title2)
                        .bold()
                    Text(avgVal == "0" ? "-.-" : avgVal)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(Color("BCGold"))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                Button {
                    showReviewViewSheet.toggle()
                } label: {
                    Image(systemName: "star.fill")
                    Text("Rate")
                }
                .font(Font.caption)
                .buttonStyle(.borderedProminent)
                .disabled(showingAsSheet)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding()
            
            List {
                Section {
                    ForEach(reviewsVM.reviews) { review in
                        NavigationLink {
                            ReviewView(menuItem: menuItem, review: review)
                        } label: {
                            ReviewRowView(review: review)
                        }
                    }
                }
            }
            .listStyle(.grouped)
            
            
            Spacer()
        }
        .task { // add to VStack - acts like .onAppear
            if showingAsSheet == false {
                reviewsVM.reviews = []
                await reviewsVM.getReviews(id: menuItem.id ?? "")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(menuItem.id == nil)
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(menuItem: menuItem, review: Review())
            }
        }
        
        .onChange(of: reviewsVM.reviews, perform: { _ in
            avgVal = String(format: "%.1f", Double(reviewsVM.reviews.reduce(0) {$0 + $1.rating}) / Double(reviewsVM.reviews.count))
        })
        .onAppear {
            if  menuItem.id == nil {
                showingAsSheet = true
            }
        }
        .toolbar {
            if (menuItem.postedBy == Auth.auth().currentUser?.uid) { //new menuItem, show Cancel / Save buttons
                if showingAsSheet {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let id = await menuItemVM.saveMenuItem(menuItem: menuItem)
                            if id != nil { // save worked!
                                dismiss()
                            } else { // did not save
                                print("😡 DANG! Error saving menuItem!")
                            }
                        }
                    }
                }
            } else if showingAsSheet && menuItem.id != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetailView(menuItem: MenuItem())
            .environmentObject(MenuItemViewModel())
    }
}
