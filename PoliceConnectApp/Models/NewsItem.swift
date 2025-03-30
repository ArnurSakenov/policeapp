//
//  NewsItem.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//
import Foundation

struct NewsItem: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var content: String
    var imageURL: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}
