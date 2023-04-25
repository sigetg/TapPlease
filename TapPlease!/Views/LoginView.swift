//
//  LoginView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import GoogleSignInSwift


@MainActor
struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("BCappIcon")
                .resizable()
                .frame(width: 300, height: 300)
                .scaledToFit()
                .padding()
            
            Spacer()
            
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email) // this field is bound to the email case
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password) // this field is bound to the .passoword case
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                        
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .disabled(buttonsDisabled)
                .padding(.trailing)
                Button {
                    login()
                } label: {
                    Text("Login")
                }
                .disabled(buttonsDisabled)
                .padding(.leading)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding()
                .padding()
            
            Button {
                Task {
                    await signInWithGoogle()
                }
            } label: {
                Image("google")
                Text("Sign In With Google")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // if logged in when the app runs, navigate to the new screen and skip the login screen
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            HomeView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration Success!")
                presentSheet = true
            }
        }
    }
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No Client ID found in Firebase Configuration")
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowSceene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowSceene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root controller")
            return false
        }
        
        // Start the sign in flow!
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                print("error!")
                return false
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            _ = try await Auth.auth().signIn(with: credential)
            presentSheet = true
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
