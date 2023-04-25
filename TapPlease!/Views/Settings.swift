//
//  Settings.swift
//  TapPlease!
//
//  Created by George Sigety on 4/24/23.
//

import SwiftUI

struct Settings: View {
    @State private var notificationsEnabled = false
    var body: some View {
        VStack {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
        }
//        .onChange(of: notificationsEnabled) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                if success {
//                    print("All set!")
//                } else if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
