//
//  ReviewView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import PhotosUI


struct ReviewView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    @Environment(\.dismiss) var dismiss
    @State private var postedByThisUser = false
    @State var menuItem: MenuItem
    @State var review: Review
    @State private var rateOrReviewerString = "Click to Rate:" //otherwise will say poster email and date
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(menuItem.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Text(menuItem.description)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(rateOrReviewerString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            
            StarsSelectionView(rating: $review.rating)
                .disabled(!postedByThisUser) // disable if not posted by this user
            
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                
                TextField("title", text: $review.title)
                    .padding(.horizontal, 6)
                    .textFieldStyle(.roundedBorder)
                
                Text("Review")
                    .bold()
                TextField("review", text: $review.body, axis: .vertical)
                    .lineLimit(5, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
            }
            .disabled(!postedByThisUser) //disable if review not posed by this user
            .padding(.horizontal)
            .font(.title2)
            
            
            HStack {
                Text("Image:")
                    .bold()
                    .font(.title2)
                Spacer()
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                    Label("", systemImage: "photo.fill.on.rectangle.fill")
                }
                .disabled(!postedByThisUser)
                .onChange(of: selectedPhoto) { newValue in
                    imageURL = nil
                    Task {
                        do {
                            if let data = try await newValue?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)                    }
                            }
                        } catch {
                            print("😡 ERROR: loading failed \(error.localizedDescription)")
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            if imageURL != nil {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            } else {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity)
            }
            Spacer()
        }
        .task { // add to VStack - acts like .onAppear
            if let id = review.id { // if this isn't a new place id
                if let url = await reviewVM.getImageURL(id: id) { // It should have a url for the image (it may be "")
                    imageURL = url
                }
            }
        }
        .onAppear {
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewerString = "by: \(review.reviewer) on: \(reviewPostedOn)"
            }
        }
        .navigationBarBackButtonHidden(postedByThisUser) //hide back button if posted by this user
        .toolbar {
            if postedByThisUser {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let id = await reviewVM.saveReview(menuItem: menuItem, review: review)
                            reviewVM.reviews = []
                            await reviewVM.getReviews(id: menuItem.id ?? "")
                            if id != nil {
                                if imageURL == nil {
                                    await reviewVM.saveImage(id: id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage() )
                                }
                                dismiss()
                            } else {
                                print(" Error saving image")
                            }
                        }
                    }
                }
                if review.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task {
                                let success = await reviewVM.deleteReview(menuItem: menuItem, review: review)
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

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(menuItem: MenuItem(), review: Review())
    }
}
