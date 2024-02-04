//
//  Item.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
