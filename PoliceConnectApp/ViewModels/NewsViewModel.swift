//
//  NewsViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import Foundation

class NewsViewModel: ObservableObject {
    @Published var news = [NewsItem]()
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        guard let url = URL(string: "http://34.88.151.210:8080/api/news") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching news: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON:\n\(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                
                if let date = formatter.date(from: dateStr) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container,
                        debugDescription: "Cannot decode date string \(dateStr)")
                }
            }
            
            do {
                let newsItems = try decoder.decode([NewsItem].self, from: data)
                DispatchQueue.main.async {
                    self.news = newsItems
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }


}

