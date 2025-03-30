//
//  LoginView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Авторизация")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Имя пользователя", text: $authVM.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Пароль", text: $authVM.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                if authVM.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        authVM.login()
                    }) {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Авторизация")
        }
    }
}
