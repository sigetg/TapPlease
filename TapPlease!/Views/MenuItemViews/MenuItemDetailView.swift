//
//  MenuItemDetailView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import PhotosUI


struct MenuItemDetailView: View {
    
    enum ButtonPressed {
        case review//, photo
    }
    
    @EnvironmentObject var menuItemVM: MenuItemViewModel
    @FirestoreQuery(collectionPath: "menuItems") var reviews: [Review]
    @Environment (\.dismiss) private var dismiss
    @State var menuItem: MenuItem
    @State private var showingAsSheet = false
    @State private var showSaveAlert = false
    @State private var showReviewViewSheet = false
    @State private var buttonPressed = ButtonPressed.review
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    var avgRating: String {
        guard reviews.count != 0 else {
            return "-.-"
        }
        let avgValue = Double(reviews.reduce(0) {$0 + $1.rating}) / Double(reviews.count)
        return String(format: "%.1f", avgValue)
    }
    
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
                    Text(avgRating)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(Color("BCGold"))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Button {
                    if menuItem.id == nil {
                        showSaveAlert.toggle()
                    } else {
                        showReviewViewSheet.toggle()
                    }
                } label: {
                    Image(systemName: "star.fill")
                    Text("Rate")
                }
                .font(Font.caption)
                .buttonStyle(.borderedProminent)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding()
            
            HStack {
                Text("Foood:")
                    .bold()
                Spacer()
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                    Label("", systemImage: "photo.fill.on.rectangle.fill")
                }
                .onChange(of: selectedPhoto) { newValue in
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
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity)
            } else {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            
            List {
                Section {
                    ForEach(reviews) { review in
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
            if let id = menuItem.id { // if this isn't a new place id
                if let url = await menuItemVM.getImageURL(id: id) { // It should have a url for the image (it may be "")
                    imageURL = url
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(menuItem.id == nil)
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(menuItem: menuItem, review: Review())
            }
        }
        //        .sheet(isPresented: $showPhotoViewSheet) {
        //            NavigationStack {
        //                PhotoView(photo: $newPhoto, uiImage: uiImageSelected, spot: spot)
        //            }
        //        }
        .onAppear {
            if  menuItem.id != nil {
                $reviews.path = "menuItems/\(menuItem.id ?? "")/reviews"
                print("reviews.path = \($reviews.path)")
                
                //                $photos.path = "spots/\(spot.id ?? "")/photos"
                //                print("photos.path = \($photos.path)")
            } else { //spot.id starts out as nil
                showingAsSheet = true
            }
        }
        .toolbar {
            if menuItem.id == nil && showingAsSheet { //new menuItem, show Cancel / Save buttons
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let id = await menuItemVM.saveMenuItem(menuItem: menuItem)
                            if id != nil { // save worked!
                                menuItem.id = id
                                print("menuItem.id = \(menuItem.id ?? "nil")")
                                await menuItemVM.saveImage(id: menuItem.id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage() )
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
//        .alert("Cannot Rate Meal Unless it Is Saved", isPresented: $showSaveAlert) {
//            Button("Cancel", role: .cancel) {}
//            Button("Save", role: .none) {
//                Task {
//                    let success = await menuItemVM.saveMenuItem(menuItem: menuItem)
//                    menuItem = menuItemVM.menuItem
//                    if success {
//                        // if we didn't update the path after saving the spot, we wouldn't be able to show new reviews added
//                        $reviews.path = "menuItems/\(menuItem.id ?? "")/reviews"
//                        //                        $photos.path = "menuItems/\(menuItem.id ?? "")/photos"
//                        switch buttonPressed {
//                        case .review:
//                            showReviewViewSheet.toggle()
//                            //                        case .photo:
//                            //                            showPhotoViewSheet.toggle()
//
//                        }
//                    } else {
//                        print("😡 Dang! Error saving spot!")
//                    }
//                }
//            }
//        } message: {
//            Text("Would you like to save this Menu Item first so that you can enter a review?")
//        }
    }
}

struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetailView(menuItem: MenuItem())
            .environmentObject(MenuItemViewModel())
    }
}
