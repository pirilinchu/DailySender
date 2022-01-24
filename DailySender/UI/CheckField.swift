//
//  CheckField.swift
//  DailySender
//
//  Created by Macbook on 22/1/22.
//

import SwiftUI
import Combine

struct CheckField: View {
    let text: String
    let OnPressed: (Meeting, Bool) -> Void
    @State var isChecked: Bool = false
    
    let NC = NotificationCenter.default
    
    var publisher = NotificationCenter.default.publisher(for: .sendPressed)
        .receive(on: RunLoop.main)
    
    var body: some View {
        Button(action: {
            isChecked = !isChecked
            OnPressed(Meeting(text: text, isMeeting: true), isChecked)
        }){
            HStack (spacing: 4) {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                if isChecked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("GreenColor"))
                }
            }

        }.buttonStyle(MyButtonStyle())
            .onReceive(publisher) { _ in
                isChecked = false
            }
    }
    
    func getText() -> String {
        text
    }
}

struct CheckField_Previews: PreviewProvider {
    static var previews: some View {
        CheckField(text: "Example", OnPressed: {(_,_) in })
    }
}

struct MyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(8.0)
    }
    
}
