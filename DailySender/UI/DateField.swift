//
//  DateField.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import SwiftUI

struct DateField: View {
    let isMeeting: Bool
    @State var text: String = ""
    let onPressed: (Meeting) -> Void
    @State var date: Date = Date()
    
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
            Text(date.dateString())
                .frame(maxWidth: .infinity)
            Button(action: {
                date.addTimeInterval(TimeInterval(-86400))
            }){
              Image(systemName: "arrowtriangle.left.square")
                    .imageScale(.large)
            }
            .buttonStyle(EnterFieldButtonStyle())
            
            Button(action: {
                date.addTimeInterval(TimeInterval(86400))
            }){
              Image(systemName: "arrowtriangle.right.square")
                    .imageScale(.large)
            }
            .buttonStyle(EnterFieldButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(8)
        .onReceive(publisher) { _ in
            date = Date()
        }
        .frame(maxWidth: .infinity)
    }
}

struct DateField_Previews: PreviewProvider {
    static var previews: some View {
        DateField(isMeeting: false, onPressed: {_ in })
    }
}

struct DateFieldButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("PrimaryColor") : Color.blue)
            .background(Color.white)
    }
    
}

extension Date {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
