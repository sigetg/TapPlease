//
//  TapPlease_App.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn


@main
struct HeightsGrubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var menuItemVM = MenuItemViewModel()
    @StateObject var mealRequestVM = MealRequestViewModel()
    @StateObject var messengerVM = MessengerViewModel()
    @StateObject var messageVM = MessageViewModel()
    @StateObject var profileVM = ProfileViewModel()

    var body: some Scene {
        
        WindowGroup {
            RootView()
                .environmentObject(menuItemVM)
                .environmentObject(mealRequestVM)
                .environmentObject(messengerVM)
                .environmentObject(messageVM)
                .environmentObject(profileVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
