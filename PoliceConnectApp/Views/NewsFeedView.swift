//
//  ContentView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.news) { item in
               
                NewsRowView(item: item)
                  
                    .contentShape(Rectangle())
                    .onTapGesture {
                  
                        path.append(item)
                    }
                 
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .navigationTitle("Новости")
            .refreshable {
                viewModel.fetchNews()
            }
          
            .navigationDestination(for: NewsItem.self) { selectedItem in
                NewsDetailView(item: selectedItem)
            }
        }
    }
}

