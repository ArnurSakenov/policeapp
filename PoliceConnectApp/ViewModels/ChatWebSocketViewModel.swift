//
//  ChatWebSocketViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//

import Foundation
import SwiftUI

class ChatWebSocketViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isConnected: Bool = false
    @Published var errorMessage: String?
    
    private var webSocketTask: URLSessionWebSocketTask?
    
   
    var userId: String = "84157d73-c387-4e05-836c-b7c899e58453"
    var role: String = "citizen"
    
    var recipientId: String? = "203f9207-4541-4e81-9d01-76d3f1ba3d0e"
    
    func connect() {
       
        guard let url = URL(string: "ws://34.88.151.210:8080/ws/chat?user_id=\(userId)&role=\(role)") else {
            errorMessage = "Неверный URL"
            return
        }
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.errorMessage = "Ошибка получения сообщения: \(error.localizedDescription)"
                case .success(let message):
                    switch message {
                    case .string(let text):
                        
                        if let data = text.data(using: .utf8) {
                            do {
                                let decoded = try JSONDecoder().decode(ChatMessage.self, from: data)
                               
                                let displayText = "Полиция: \(decoded.message)"
                                self?.messages.append(Message(text: displayText, sender: .ai, date: Date()))
                            } catch {
                                self?.messages.append(Message(text: text, sender: .ai, date: Date()))
                            }
                        }
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            self?.messages.append(Message(text: text, sender: .ai, date: Date()))
                        }
                    @unknown default:
                        break
                    }
                   
                    self?.receiveMessage()
                }
            }
        }
    }

    
    func sendMessage() {
        let messageText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageText.isEmpty, let task = webSocketTask else { return }
      
        var json: [String: Any] = [
            "message": messageText
        ]
        if let recipientId = recipientId, !recipientId.isEmpty {
            json["recipient_id"] = recipientId
        } else {
            json["recipient_id"] = NSNull()
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let message = URLSessionWebSocketTask.Message.string(jsonString)
                task.send(message) { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.errorMessage = "Ошибка отправки сообщения: \(error.localizedDescription)"
                        } else {
                          
                            self?.messages.append(Message(text: "Вы: \(messageText)", sender: .user, date: Date()))
                            self?.inputText = ""
                        }
                    }
                }
            }
        } catch {
            errorMessage = "Ошибка формирования сообщения"
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
}
