//
//  ChatViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI
import Alamofire

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var inputText = ""
    @Published var isLoading = false
    
    private let openAIKey = ""
    
    func sendMessage() {
        let userMessage = Message(text: inputText, sender: .user, date: Date())
        messages.append(userMessage)
        
        let prompt = inputText
        inputText = ""
        isLoading = true
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openAIKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "Ты помощник полицейского оператора. Общайся кратко и четко."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        AF.request("https://api.openai.com/v1/chat/completions",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: OpenAIResponse.self) { response in
            self.isLoading = false
            switch response.result {
            case .success(let data):
                if let aiText = data.choices.first?.message.content {
                    let aiMessage = Message(text: aiText, sender: .ai, date: Date())
                    self.messages.append(aiMessage)
                }
            case .failure(let error):
                print("Ошибка OpenAI: \(error)")
            }
        }
    }
}


struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
