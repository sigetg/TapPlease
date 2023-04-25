//
//  MessageField.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messageVM: MessageViewModel
    @State var messages: [Message]
    @State var message: Message
    @State var messenger: Messenger
    @State private var inputMessage = ""

    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $inputMessage)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                message.text = inputMessage
                Task {
                    await messageVM.sendMessage(messenger: messenger, message: message)
                }
                inputMessage = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("AccentColor"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField(messages: [Message(), Message()], message: Message(), messenger: Messenger())
            .environmentObject(MessageViewModel())
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
