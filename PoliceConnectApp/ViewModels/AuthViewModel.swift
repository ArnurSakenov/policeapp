//
//  AuthViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//

import Foundation
import Combine
import SwiftOTP
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
   
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var token: String? {
        didSet {
            
            if let token = token {
                UserDefaults.standard.set(token, forKey: "authToken")
            }
        }
    }
    
   
    private let totpSecret = "5WKNLSQOITQCXG36OYJBOFQ2KNV5JRNF"
    
    
    func generateTOTPCode() -> String? {
        guard let secretData = base32DecodeToData(totpSecret) else {
            return nil
        }
        if let totp = TOTP(secret: secretData, digits: 6, timeInterval: 30, algorithm: .sha1) {
            let code = totp.generate(time: Date())
            print("Generated TOTP code: \(code ?? "nil")")
            return code
        }
        return nil
    }

    
    func login() {
        guard let url = URL(string: "http://34.88.151.210:8080/api/auth/login") else {
            errorMessage = "Неверный URL"
            return
        }
        guard let totpCode = generateTOTPCode() else {
            errorMessage = "Ошибка генерации TOTP"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "totp_code": totpCode
        ]
        
        
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            isLoading = false
            errorMessage = "Ошибка формирования запроса"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    self?.errorMessage = "Не получены данные"
                    return
                }
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
                do {
                    let decoder = JSONDecoder()
                    let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                    self?.token = loginResponse.token
                } catch {
                    self?.errorMessage = "Ошибка декодирования: \(error)"
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}


func base32DecodeToData(_ string: String) -> Data? {
    let base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    var string = string.uppercased().replacingOccurrences(of: "=", with: "")
    var bytes = [UInt8]()
    var buffer: UInt64 = 0
    var bitsLeft = 0
    
    for char in string {
        guard let index = base32Alphabet.firstIndex(of: char)?.utf16Offset(in: base32Alphabet) else {
            return nil
        }
        buffer = (buffer << 5) | UInt64(index)
        bitsLeft += 5
        if bitsLeft >= 8 {
            let byte = UInt8((buffer >> UInt64(bitsLeft - 8)) & 0xff)
            bytes.append(byte)
            bitsLeft -= 8
        }
    }
    return Data(bytes)
}
