//
//  Settings.swift
//  TapPlease!
//
//  Created by George Sigety on 4/24/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var profileVM: ProfileViewModel
//    @StateObject var manager = NotificationManager()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    var body: some View {
        List {
            if let user = profileVM.user {
                HStack {
                    Text("Name: ")
                        .bold()
                    Text("\(user.name ?? "")")
                    Spacer()
                    Text("\(user.tapperLevel ?? "")")
                    if user.tapperLevel == "1" {
                        Image(systemName: "star")
                    } else if user.tapperLevel == "2" {
                        Image(systemName: "star.fill")
                    } else if user.tapperLevel == "3" {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BCMaroon"))
                    } else if user.tapperLevel == "4" {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BCGold"))
                    } else {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(Color("BCGold"))
                    }
                }
                HStack {
                    Text("Email: ")
                        .bold()
                    Text("\(user.email ?? "")")
                }
                VStack(alignment: .center) {
                    
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
                Section {
                    Button("Log out") {
                        Task {
                            do {
                                try profileVM.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .task {
            try? await profileVM.loadCurrentUser()
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
                    EditProfileView(showSignInView: $showSignInView)
                } label: {
                    Text("Edit Profile")
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
