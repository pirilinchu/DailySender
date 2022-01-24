//
//  ItemProtocol.swift
//  DailySender
//
//  Created by Macbook on 23/1/22.
//

import Foundation

protocol Item {
    var message: String { get }
    var id: Int { get }
}
