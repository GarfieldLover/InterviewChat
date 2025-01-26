//
//  Item.swift
//  InterviewChat
//
//  Created by macbook on 2025/1/26.
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
