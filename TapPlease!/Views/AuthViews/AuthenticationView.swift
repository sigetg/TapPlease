//
//  AuthenticationView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/26/23.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestoreSwift
import GoogleSignInSwift


import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}

//struct AuthenticationView: View {
//    @State private var presentSheet = false
//    @State private var newUser = true
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            Image("BCappIcon")
//                .resizable()
//                .frame(width: 300, height: 300)
//                .scaledToFit()
//                .padding()
//
//            Spacer()
//
//            VStack {
//                NavigationLink {
//                    LoginView()
//                } label: {
//                    Text("Sign In With Email")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//
//                Button {
//                    Task {
//                        await signInWithGoogle()
//                    }
//                } label: {
//                    HStack {
//                        Image("google")
//                        Text("Sign In With Google")
//                    }
//                }
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(height: 55)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .cornerRadius(10)
//
//            }
//            .padding()
//        }
//        .fullScreenCover(isPresented: $presentSheet) {
//            if newUser {
//                ProfileView(user: currentUser)
//            } else {
//                HomeView()
//            }
//        }
//    }
//
//    func signInWithGoogle() async -> Bool {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No Client ID found in Firebase Configuration")
//        }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        guard let windowSceene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = await windowSceene.windows.first,
//              let rootViewController = await window.rootViewController else {
//            print("There is no root controller")
//            return false
//        }
//
//        // Start the sign in flow!
//        do {
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else {
//                print("error!")
//                return false
//            }
//            let accessToken = user.accessToken
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            _ = try await Auth.auth().signIn(with: credential)
//            presentSheet = true
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
//
//}
//
//
//struct AuthenticationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticationView()
//    }
//}
