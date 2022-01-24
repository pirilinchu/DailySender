//
//  Meeting.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import Foundation

class Meeting: Item {
    var id: Int = -1
    let text: String
    let isMeeting: Bool

    init (text: String, isMeeting: Bool) {
        self.text = text
        self.isMeeting = isMeeting
    }
    
    var message: String {
        let prefix = isMeeting ? "- Attend " : "- "
        return prefix + text
    }
}

extension String {
    func isValidMeeting() -> Bool {
        return self.isEmpty ? false : true
    }
}
