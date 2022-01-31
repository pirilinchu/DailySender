//
//  EnterField.swift
//  DailySender
//
//  Created by Macbook on 22/1/22.
//

import SwiftUI

struct EnterField: View {
    let isMeeting: Bool
    @State var text: String = ""
    let onPressed: (Meeting) -> Void
    
    var prefix: String {
        isMeeting ? "Attend " : ""
    }
    
    var insertedText: String {
        text
    }
    
    var placeHolder: String {
        isMeeting ? "Meeting" : "Extra"
    }
    
    var publisher = NotificationCenter.default.publisher(for: .sendPressed)
        .receive(on: RunLoop.main)
    
    var body: some View {
        HStack (spacing: 4) {
            TextField( placeHolder, text: $text, onCommit: {
                guard text.isValidMeeting() else { return }
                onPressed(Meeting(text: text, isMeeting: isMeeting))
                text = ""
            })
                .textFieldStyle(PlainTextFieldStyle())
            Button("Add") {
                guard text.isValidMeeting() else { return }
                onPressed(Meeting(text: text, isMeeting: isMeeting))
                text = ""
            }
            .buttonStyle(EnterFieldButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(8)
        .onReceive(publisher) { _ in
            text = ""
        }
    }
}

struct EnterField_Previews: PreviewProvider {
    static var previews: some View {
        EnterField(isMeeting: false, onPressed: {_ in })
    }
}

struct EnterFieldButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("PrimaryColor") : Color.blue)
            .background(Color.white)
    }
    
}
