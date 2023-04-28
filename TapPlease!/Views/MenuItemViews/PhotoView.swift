//
//  PhotoView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/28/23.
//

import SwiftUI
import Firebase

struct PhotoView: View {
    @EnvironmentObject var menuItemVM: MenuItemViewModel
    @Binding var photo: Photo
    var uiImage: UIImage
    var menuItem: MenuItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(Auth.auth().currentUser?.uid != photo.postedBy)
                
                Text("by: \(photo.postedBy) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .toolbar {
                if Auth.auth().currentUser?.uid == photo.postedBy {
                    //image was posted by current user
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button("Save") {
                            Task {
                                let id = menuItem.id
                                if id != nil { // save worked!
                                    print("menuItem.id = \(menuItem.id ?? "nil")")
                                    await menuItemVM.saveImage(id: id ?? "", photo: photo, image: uiImage)
                                    dismiss()
                                } else { // did not save
                                    print("😡 DANG! Error saving menuItem!")
                                }
                            }
                        }
                    }
                } else {
                    //image was NOT posted by current user
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .constant(Photo()), uiImage: UIImage(named: "pizza") ?? UIImage(), menuItem: MenuItem())
            .environmentObject(MenuItemViewModel())
    }
}
