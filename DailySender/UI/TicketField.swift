//
//  TicketField.swift
//  DailySender
//
//  Created by Macbook on 22/1/22.
//

import SwiftUI
import Combine

enum TicketType: String {
    case defect = "D-"
    case feature = "B-"
}

struct TicketField: View {
    @State var type : TicketType? = nil
    @State var text: String = ""
    @State var isFinished: Bool = false
    let onPressed: (Ticket) -> Void
    
    var ticketType: String {
        type?.rawValue ?? ""
    }
    
    var typeImage: String {
        switch type {
        case .feature: return "b.square.fill"
        case .defect: return "d.square.fill"
        default: return ""
        }
    }
    
    var typeColor: Color {
        switch type {
        case .feature: return Color("GreenColor")
        case .defect: return Color("RedColor")
        default: return Color.white
        }
    }
    
    var insertedText: String {
        text
    }
    
    var placeHolder = "Code"
    
    var textColor: Color {
        return text.count > 5 ? Color.red : Color.black
    }
    var publisher = NotificationCenter.default.publisher(for: .sendPressed)
        .receive(on: RunLoop.main)
    
    var body: some View {
        
        if let type = type {
            HStack (spacing: 4) {
                Image(systemName: typeImage)
                    .foregroundColor(typeColor)
                    .imageScale(.large)
                TextField( placeHolder, text: $text)
                    .onReceive(Just(text)) { newValue in
                         let filtered = newValue.filter { "0123456789".contains($0) }
                         if filtered != newValue {
                             self.text = filtered
                         }
                    }
                    .foregroundColor(textColor)
                    .textFieldStyle(PlainTextFieldStyle())
                Toggle(isOn: $isFinished){
                    Text("Done")
                }
                .toggleStyle(.switch)
                .padding(.horizontal, 10)
                .frame(maxHeight: 10)
                
                Button("Add") {
                    guard text.isValidCode() else { return }
                    onPressed(Ticket(type: type, code: text, isFinished: isFinished))
                    //reset everything
                    isFinished = false
                    text = ""
                    self.type = nil
                }
                .buttonStyle(EnterFieldButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(8)
            .onReceive(publisher) { _ in
                isFinished = false
                text = ""
                self.type = nil
            }
        }  else {
            HStack (spacing: 0) {
                Button(action: {
                    type = .feature
                }) {
                    ZStack {
                        Image(systemName: "b.square.fill")
                            .foregroundColor(Color.white)
                            .imageScale(.large)
                            .background(Color("GreenColor"))
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 48)
                    .background(Color("GreenColor"))
                    
                }
                .buttonStyle(TicketFieldButtonStyle())
                .background(Color("GreenColor"))
                
                Button(action: {
                    type = .defect
                }) {
                    ZStack {
                        Image(systemName: "d.square.fill")
                            .foregroundColor(Color.white)
                            .imageScale(.large)
                            .background(Color("RedColor"))
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 48)
                    .background(Color("RedColor"))
                    
                }
                .buttonStyle(TicketFieldButtonStyle())
                .background(Color("RedColor"))

            }
            .background(Color.white)
            .cornerRadius(8)
            .onReceive(publisher) { _ in
                isFinished = false
                text = ""
                self.type = nil
            }
        }
        
    }
}

struct TicketField_Previews: PreviewProvider {
    static var previews: some View {
        TicketField() { _ in
        }
    }
}

struct TicketFieldButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .cornerRadius(8.0)
            .frame(maxWidth: .infinity)
    }
    
}
