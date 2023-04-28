//
//  RootView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/26/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                HomeView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        //SEND REQUEST TO RECIEVE NOTIFICATIONS
//        .onAppear {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                if granted {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//
//            NotificationCenter.default.addObserver(forName: Notification.Name("didRegisterForRemoteNotificationsWithDeviceToken"), object: nil, queue: .main) { notification in
//                if let deviceToken = notification.object as? String {
//                    UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
//                }
//            }
//        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
