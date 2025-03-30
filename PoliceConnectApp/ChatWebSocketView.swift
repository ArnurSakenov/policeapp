//
//  ChatWebSocketView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//
import SwiftUI

struct ChatWebSocketView: View {
    @StateObject private var viewModel = ChatWebSocketViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    List(viewModel.messages) { message in
                        HStack {
                            if message.sender == .ai {
                                Image(systemName: "bubble.left")
                                    .foregroundColor(.blue)
                            }
                            VStack(alignment: .leading) {
                                Text(message.text)
                                    .padding(8)
                                    .background(message.sender == .user ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                                Text("\(message.date.formatted(.dateTime.hour().minute()))")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: message.sender == .user ? .trailing : .leading)
                            if message.sender == .user {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .id(message.id)
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                HStack {
                    TextField("Сообщение...", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(viewModel.inputText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Чат с оператором")
            .onAppear {
                viewModel.connect()
            }
            .onDisappear {
                viewModel.disconnect()
            }
        }
    }
}
