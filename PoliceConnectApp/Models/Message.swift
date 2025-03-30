//
//  Message.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import Foundation

struct Message: Identifiable, Codable { 
    enum Sender: String, Codable {
        case user, ai
    }
    
    let id = UUID()
    let text: String
    let sender: Sender
    let date: Date
}
