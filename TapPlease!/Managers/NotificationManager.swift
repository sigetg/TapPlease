//
//  Notification Helper.swift
//  TapPlease!
//
//  Created by George Sigety on 4/28/23.
//

import Foundation

//Will implement once I get the apple dev account
final class NotificationManager: ObservableObject {
    
    func sendNotification(deviceToken: String, message: String, sender: String) {
        // Set up the message data
        let message = ["title": "\(sender)", "body": "\(message)"]
        let token = deviceToken
        let data: [String: Any] = ["notification": message, "token": token]
        
        // Set up the URL and request
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=<your-server-key>", forHTTPHeaderField: "Authorization")
        
        // Encode the data as JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else { return }
        
        // Attach the JSON data to the request
        request.httpBody = jsonData
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("Error sending notification: Status code \(response.statusCode)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Notification sent successfully: \(dataString)")
            }
        }
        task.resume()
    }

}
