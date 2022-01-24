//
//  Ticket.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import Foundation

class Ticket: Item{
    var id: Int = -1
    let type: TicketType
    let code: String
    let isFinished: Bool
    
    init(type: TicketType, code: String, isFinished: Bool) {
        self.type = type
        self.code = code
        self.isFinished = isFinished
        self.id = 4
    }
    
    var message: String {
        return "- Work on " + (type.rawValue) + code
    }
    
    var futureMessage: String? {
        return isFinished ? nil : ("- Continue working on " + (type.rawValue) + code)
    }
}

extension String {
    func isValidCode() -> Bool {
        return self.count == 5 ? true : false
    }
}
