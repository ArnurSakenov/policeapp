//
//  Incident.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import Foundation
import FirebaseFirestoreSwift

struct Incident: Identifiable, Codable {
    @DocumentID var id: String?
    var description: String
    var imageUrl: String?
    var videoUrl: String?
    var isAnonymous: Bool
    var createdAt: Date
    var latitude: Double?
    var longitude: Double?
}
