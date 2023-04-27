//
//  SettingsView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/26/23.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var profileVM: ProfileViewModel
    @Binding var showSignInView: Bool
    @Environment (\.dismiss) private var dismiss

    @State private var passwordAlertIsPresented = false
    @State private var emailAlertIsPresented = false
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var newEmail = ""
    @State private var tempName = ""

    var body: some View {
        List {
            if let user = profileVM.user {
                HStack {
                    Text("Name:")
                    TextField("name...", text: $tempName)
                }
                HStack {
                    Text("Email:")
                    TextField("email...", text: $newEmail)
                    
                }
            }
            if profileVM.authProviders.contains(.email) {
                emailSection
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await profileVM.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete account")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        do {
                            try await profileVM.updateEmail(email: newEmail)
                            print("EMAIL UPDATED!")
                            try await profileVM.updateUserName(newName: tempName)
                            print("NAME UPDATED")
                        } catch {
                            print(error)
                        }
                    }
                    dismiss()
                }
            }
        }
        .task {
            try? await profileVM.loadCurrentUser()
        }
        .onAppear {
//            profileVM.loadAuthProviders()
//            profileVM.loadAuthUser()
            
            tempName = profileVM.user?.name ?? ""
            newEmail = profileVM.user?.email ?? ""

        }
        .navigationBarTitle("Edit Profile")
        .navigationBarBackButtonHidden()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView(showSignInView: .constant(false))
        }
    }
}

extension EditProfileView {
    
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await profileVM.resetPassword()
                        print("PASSWORD RESET!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update password") {
                passwordAlertIsPresented = true
            }
            
            Button("Update email") {
                emailAlertIsPresented = true
            }
        } header: {
            Text("Email functions")
        }
    }
}

    
