//
//  MessageBubble.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/13/24.
//

import SwiftUI

import SwiftUI

struct MessageBubble: View {
    var message: Message
    
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.received ? Color.gray.opacity(0.3) : Color.green)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}



struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "123", text: "Shut up Thomas! You have a screw loose!", received: false, timestamp: Date()))
    }
}



