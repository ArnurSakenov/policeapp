//
//  NewsDetailView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//
import SwiftUI

struct NewsDetailView: View {
    let item: NewsItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !item.imageURL.isEmpty {
                    AsyncImage(url: URL(string: "http://34.88.151.210:8080" + item.imageURL)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                    .clipped()
                }
                
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(item.content)
                    .font(.body)
                    .lineSpacing(5)
                
                Text("Опубликовано: \(item.createdAt.formatted(.dateTime.day().month().year().hour().minute()))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Новость")
        .navigationBarTitleDisplayMode(.inline)
    }
}
