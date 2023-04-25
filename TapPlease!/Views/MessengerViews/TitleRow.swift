//
//  TitleRow.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI
import Firebase

struct TitleRow: View {
    @State var messenger: Messenger
    var imageUrl = URL(string: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8")
    
    var body: some View {
        HStack(spacing: 20) {
//            AsyncImage(url: imageUrl) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(50)
//            } placeholder: {
//                ProgressView()
//            }
            
            VStack(alignment: .leading) {
                Text(messenger.reciever == Auth.auth().currentUser?.email ? messenger.sender : messenger.reciever)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
        }
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(messenger: Messenger())
            .background(Color("Peach"))
    }
}
