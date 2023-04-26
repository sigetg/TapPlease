//
//  Settings.swift
//  TapPlease!
//
//  Created by George Sigety on 4/24/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    @State private var tempName = DBUser.init(userId: "", name: "").name
    
    var body: some View {
        List {
            if let user = profileVM.user {
                Text("UserId: \(user.userId)")
                TextField("enter name...", text: Binding(
                    get: { self.tempName ?? "" },
                    set: { self.tempName = $0.isEmpty ? nil : $0 }
                ))
                VStack {
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select a photo")
                    }
                    
                    
                    if let urlString = profileVM.user?.profileImagePathUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 150)
                        }
                    }
                    
                    if profileVM.user?.profileImagePath != nil {
                        Button("Delete image") {
                            profileVM.deleteProfileImage()
                        }
                    }
                }
            }
        }
        .task {
            try? await profileVM.loadCurrentUser()
            if let user = profileVM.user {
                tempName = profileVM.user?.name
            }
        }
        .onChange(of: selectedItem, perform: { newValue in
            if let newValue {
                profileVM.saveProfileImage(item: newValue)
            }
        })
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

//import SwiftUI
//import Firebase
//
//struct ProfileView: View {
//    @EnvironmentObject var userVM: UserViewModel
//    @Environment(\.dismiss) private var dismiss
//    @State var user: User
//    @State private var notificationsEnabled = false
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("Profile")
//                    .font(.largeTitle)
//                    .bold()
//                Image(systemName: "star")
//                    .tint(Color("BCGold"))
//                Text(user.tapperLevel)
//            }
//
//            Text("Name:")
//                .bold()
//                .padding(.top)
//
//            TextField("enter name", text: $user.name)
//                .padding(.horizontal, 6)
//                .textFieldStyle(.roundedBorder)
//            Text("\(user.name) is the name ")
//            HStack {
//                Text("Email:")
//                    .bold()
//                Text((user.email ?? (Auth.auth().currentUser?.email ?? "")))
//            }
//                .lineLimit(5, reservesSpace: true)
//                .textFieldStyle(.roundedBorder)
//            Toggle("Enable Notifications", isOn: $notificationsEnabled)
//
//            Spacer()
//        }
//        .onAppear {
//            user = userVM.getCurrentUser(email: Auth.auth().currentUser?.email ?? "")!
//        }
//        .padding()
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Cancel") {
//                    dismiss()
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Save") {
//                    Task {
//                        await userVM.saveUser(user: user)
//                    }
//                    dismiss()
//                }
//            }
//        }
//
//
//        //        .onChange(of: notificationsEnabled) {
//        //            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//        //                if success {
//        //                    print("All set!")
//        //                } else if let error = error {
//        //                    print(error.localizedDescription)
//        //                }
//        //            }
//        //        }
//    }
//}
//
//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: User())
//    }
//}
