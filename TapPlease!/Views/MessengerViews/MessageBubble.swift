//
//  MessageBubble.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI
import Firebase

struct MessageBubble: View {
    @State var message: Message
    @State private var showTime = false
    @State var messenger: Messenger
    
    var body: some View {
        VStack(alignment: message.sender != Auth.auth().currentUser?.email ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.sender != Auth.auth().currentUser?.email ? Color("Gray") : Color("AccentColor"))
                    .foregroundColor(message.sender != Auth.auth().currentUser?.email ? .black : .white)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.sender != Auth.auth().currentUser?.email ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.sender != Auth.auth().currentUser?.email ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.sender != Auth.auth().currentUser?.email ? .leading : .trailing)
        .padding(message.sender != Auth.auth().currentUser?.email ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "1111", text: "Hola", timestamp: Date()), messenger: Messenger())
    }
}
