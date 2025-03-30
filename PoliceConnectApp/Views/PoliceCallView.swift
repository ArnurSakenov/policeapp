//
//  PoliceCallView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI

struct PoliceCallView: View {
    @Environment(\.openURL) var openURL
    
    // Фиксированный номер (замените на реальный)
    let policePhoneNumber = "tel://+1234567890"
    
    @State private var showAlert = false
    @State private var timerActive = false
    @State private var isShaken = false  // ← выставляется при тряске

    var body: some View {
        // Оборачиваем основной контент в ShakeDetectingView
        ShakeDetectingView(isShaken: $isShaken) {
            VStack {
                Spacer()

                // Красивая иконка телефона
                Image(systemName: "phone.fill.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding()

                // Заголовок
                Text("Экстренный вызов")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.bottom, 4)

                // Подзаголовок
                Text("Встряхните телефон или нажмите кнопку, чтобы позвонить в полицию")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                // Кнопка вызова
                Button(action: {
                    callPolice()
                }) {
                    Text("Позвонить в ближайший участок")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .padding(.top, 40)
            // Алерт, который появляется при тряске
            .alert("Вызов полиции", isPresented: $showAlert) {
                Button("Отмена", role: .cancel) {
                    timerActive = false
                }
                Button("Позвонить") {
                    timerActive = false
                    callPolice()
                }
            } message: {
                Text("Устройство зафиксировало тряску. Позвонить в полицию?")
            }
        }
        
        .onChange(of: isShaken) { newValue in
            if newValue {
                
                isShaken = false
                
                showAlert = true
                timerActive = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    if timerActive {
                        callPolice()
                    }
                }
            }
        }
    }
    
    func callPolice() {
        if let url = URL(string: policePhoneNumber) {
            openURL(url)
        }
    }
}
