//
//  MessengerView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/23/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MessengerDetailView: View {
    @EnvironmentObject var messageVM: MessageViewModel
    @EnvironmentObject var messengerVM: MessengerViewModel
    @EnvironmentObject var mealRequestVM: MealRequestViewModel
    @Environment(\.dismiss) var dismiss
    @State var messenger: Messenger
    @State var mealRequest = MealRequest()
    @State private var isFirstChange = true
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(messenger: messenger, mealRequest: mealRequest)
                    .background(Color("Gray"))
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messageVM.messages) { message in
                            MessageBubble(message: message, messenger: messenger)
                        }
                    }
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                    .onChange(of: messageVM.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(messageVM.messages[messageVM.messages.endIndex-1].id)
                        }
                    }
                }
            }
            .background(.white)
            .task {
                if await mealRequestVM.getMealRequest(id: messenger.mealRequestID) == nil {
                    print("could not get mealRequest. returned nil")
                } else {
                    mealRequest = await mealRequestVM.getMealRequest(id: messenger.mealRequestID)!
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Food Delivered!") {
                        Task {
                            let success = await messengerVM.deleteMessenger(messenger: messenger)
                            let success2 = await mealRequestVM.deleteMealRequest(mealRequest: mealRequest)
                            if success && success2 {
                                dismiss()
                            }
                        }
                    }
                }
            }
            .onAppear {
                messageVM.getMessages(messenger: messenger, messages: messageVM.messages)
            }
            
            MessageField(messages: messageVM.messages, message: Message(), messenger: messenger)
                .environmentObject(messageVM)
        }
    }
}

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerDetailView(messenger: Messenger(reciever: "Bob"))
    }
}
