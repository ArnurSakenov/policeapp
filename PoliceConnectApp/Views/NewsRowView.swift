//
//  NewsRowView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//
import SwiftUI

struct NewsRowView: View {
    let item: NewsItem
    
    
    private var excerpt: String {
        let maxCount = 50
        if item.content.count > maxCount {
            let index = item.content.index(item.content.startIndex, offsetBy: maxCount)
            return String(item.content[..<index]) + "..."
        } else {
            return item.content
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
              
                Text(excerpt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(item.createdAt.formatted(.dateTime.day().month().year().hour().minute()))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !item.imageURL.isEmpty {
                AsyncImage(url: URL(string: "http://34.88.151.210:8080" + item.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .clipped()
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
