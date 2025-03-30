//
//  ContentView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("authToken") var token: String?
    
    var body: some View {
        if let token = token, !token.isEmpty {
            
            MainTabView()
        } else {
          
            LoginView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsFeedView()
                .tabItem {
                    Label("Новости", systemImage: "list.bullet.rectangle")
                }
            
            IncidentReportView()
                .tabItem {
                    Label("Сообщить", systemImage: "exclamationmark.bubble.fill")
                }
            
            ChatWebSocketView()
                           .tabItem {
                               Label("Чат", systemImage: "message.fill")
                           }
                       
            
            PoliceCallView()
                .tabItem {
                    Label("Вызов", systemImage: "phone.fill")
                }
        }
    }
}
