//
//  HomeView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import UserNotifications

struct HomeView: View {
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        VStack {
            //            Button("Schedule Notification") {
            //                let content = UNMutableNotificationContent()
            //                content.title = "Feed the cat"
            //                content.subtitle = "It looks hungry"
            //                content.sound = UNNotificationSound.default
            //
            //                // show this notification five seconds from now
            //                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //
            //                // choose a random identifier
            //                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            //
            //                // add our notification request
            //                UNUserNotificationCenter.current().add(request)
            //            }
        }
        
        TabView {
            
            NavigationStack {
                MealRequestListView()
            }
            .tabItem() {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                Text("Requests")
            }
            
            NavigationStack {
                MessengerListView()
            }
            .tabItem() {
                Image(systemName: "message.fill")
                Text("Messages")
            }
            
            NavigationStack {
                MenuItemListView()
            }
            .tabItem() {
                Image(systemName: "menucard")
                Text("Reviews")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSignInView: .constant(false))
    }
}
