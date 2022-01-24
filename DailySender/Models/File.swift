//
//  File.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import SwiftUI

class ItemText: Identifiable {
    let id = UUID()
    let text: Text
    let isHeader: Bool
    let item: Item?
    let editable: Bool
    
    init (_ text: String, isHeader: Bool = false, item: Item? = nil, editable: Bool = false) {
        self.text = Text(text)
            .font(.system(size: 18))
            .fontWeight(isHeader ? .semibold : .light)
        self.isHeader = isHeader
        self.item = item
        self.editable = editable
    }
}
