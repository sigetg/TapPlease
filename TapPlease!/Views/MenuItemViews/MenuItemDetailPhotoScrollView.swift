//
//  MenuItemDetailPhotoScrollView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/28/23.
//

import SwiftUI

struct MenuItemDetailPhotoScrollView: View {
//    struct FakePhoto: Identifiable {
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-768b5.appspot.com/o/3gtdLq7KGYHSCEwrQp1e%2F1D563C97-0B09-4DAC-8139-8F6C7D241DB2.jpeg?alt=media&token=7da49b4a-e7cf-4e3e-90e3-f223e2df9572"
//    }
//    let photos = [FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto()]
    
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    var photos: [Photo]
    var menuItem: MenuItem

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4){
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable() //the order is important here!
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }
                        
                        
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)

                    }

                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(photo: $selectedPhoto, uiImage: uiImage, menuItem: menuItem)
        }
    }
}

struct MenuItemDetailPhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetailPhotoScrollView(photos: [Photo(imageURLString: "")], menuItem: MenuItem(id: ""))
    }
}
