//
//  ContentView.swift
//  DailySender
//
//  Created by Macbook on 22/1/22.
//

import SwiftUI

struct ContentView: View {
    
    //DATA
    @State var items: [Int: [Item]] = [:]
    
    @State var date: Date = Date()
    
    var subject: String {
        "ECI – Mobile - Daily Report - \(date.dateString())"
    }
    
    var mail: String {
        var whatIDid: String = "\nWhat I Did: \n\n"
        var whatIwillDo: String = "\nWhat I'll do: \n\n"
        let itemsSorted = items.sorted {$0.key < $1.key}
        itemsSorted.forEach { (key, items) in
            if !items.isEmpty {
                items.forEach { item in
                    whatIDid += item.message
                    whatIDid += "\n"
                    if let ticket = item as? Ticket, let message = ticket.futureMessage {
                        whatIwillDo += message
                        whatIwillDo += "\n"
                    }
                }
            }
        }
        if whatIwillDo == "\nWhat I'll do: \n\n" {
            whatIwillDo += "- Take new PBIs \n"
        }
        
        var mail = whatIDid + whatIwillDo
        mail += "\nI’m blocked with: \n\n"
        mail += "- None \n"
        mail += "\n\nSantiago Mendoza"
        
        return items.isEmpty ? "" : mail
    }
    
    var mailTexts: [ItemText] {
        var whatIDid: [ItemText] = [ItemText("What I Did:", isHeader: true)]
        var whatIwillDo: [ItemText] = [ItemText("What I'll do:", isHeader: true)]
        let itemsSorted = items.sorted {$0.key < $1.key}
        itemsSorted.forEach { (key, items) in
            if !items.isEmpty {
                items.forEach { item in
                    whatIDid.append(ItemText(item.message, item: item, editable: true))
                    if let ticket = item as? Ticket, let message = ticket.futureMessage {
                        whatIwillDo.append(ItemText(message, editable: true))
                    }
                }
            }
        }
        if whatIwillDo.count == 1 {
            whatIwillDo.append(ItemText("- Take new PBIs"))
        }
        
        var mail = whatIDid + whatIwillDo
        mail.append(ItemText("I’m blocked with:", isHeader: true))
        mail.append(ItemText("- None"))
        
        return items.isEmpty ? [] : mail
    }
    
    func addItem(_ item: Item) {
        if items[item.id] == nil {
            items[item.id] = []
        }
        items[item.id]?.append(item)
        print(items)
    }
    
    func removeItem(_ item: Item) {
        if let index = items[item.id]?.firstIndex(where: {
            $0.message == item.message
        }) {
            items[item.id]?.remove(at: index)
        }
    }

    var body: some View {
        GeometryReader { gp in
            HStack(spacing: 0){
                VStack {
                    Button() {
                        items = [:]
                        date = Date()
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .sendPressed, object: nil)
                        }
                    } label: {
                        Text("Clear")
                            .font(.system(size: 16))
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topTrailing
                      )
                    .buttonStyle(ClearButtonStyle())
                    
                    DateField(isMeeting: true) { dateChanged in
                        date = dateChanged
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 5)
                    
                    Text("Meetings")
                        .foregroundColor(Color.white)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    CheckField(text: "Standup/Sync Meeting", OnPressed: { meeting, add in
                        if add {
                            meeting.id = 0
                            addItem(meeting)
                            print("add \(meeting.message)")
                        } else {
                            meeting.id = 0
                            removeItem(meeting)
                            print("remove \(meeting.message)")
                        }
                    })
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    CheckField(text: "Daily Standup - Service Tools Team", OnPressed: { meeting, add in
                        if add {
                            meeting.id = 1
                            addItem(meeting)
                            print("add \(meeting.message)")
                        } else {
                            meeting.id = 1
                            removeItem(meeting)
                            print("remove \(meeting.message)")
                        }
                    })
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    EnterField(isMeeting: true, onPressed: { meeting in
                        meeting.id = 2
                        addItem(meeting)
                        print(meeting.message)
                    })
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    Text("Work on")
                        .foregroundColor(Color.white)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    TicketField(onPressed: { ticket in
                        addItem(ticket)
                        print(ticket.message)
                    })
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                    
                    EnterField(isMeeting: false, onPressed: { extra in
                        extra.id = 3
                        addItem(extra)
                        print(extra.message)
                    })
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                }
                .frame(width: gp.size.width * 0.4, height: gp.size.height)
                .background(Color("PrimaryColor"))
                VStack {
                    List(mailTexts) {item in
                        item.text.onTapGesture {
                            if !item.isHeader, let textItem = item.item, textItem.message != "- Attend Standup/Sync Meeting", textItem.message != "- Attend Daily Standup - Service Tools Team" {
                                removeItem(textItem)
                            }
                        }
                    }
                    .padding(.vertical, 40)
                    .padding(.horizontal, 40)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                      )
                    
                    Button {
                        //send
                        Utils.shared.sendMail(body: mail, subject: subject)
                        //delete everything
                        items = [:]
                        date = Date()
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .sendPressed, object: nil)
                        }
                    } label: {
                        Text("Send")
                            .font(.system(size: 16))
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .bottomTrailing
                      )
                    .buttonStyle(SendButtonStyle())

                }
                .frame(width: gp.size.width * 0.6, height: gp.size.height)
                .background(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(minWidth: 1000, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SendButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("PrimaryColor") : Color.blue)
            .background(Color.white)
            .padding(.bottom, 40)
            .padding(.trailing, 40)
    }
    
}

struct ClearButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("PrimaryColor") : Color.blue)
            .background(Color("PrimaryColor"))
            .padding(.bottom, 5)
            .padding(.trailing, 40)
    }
    
}

extension Notification.Name {
    static let sendPressed = Notification.Name("DeleteEverything")
}
