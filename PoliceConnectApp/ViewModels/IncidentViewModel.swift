//
//  IncidentViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI
import Alamofire
import CoreLocation

class IncidentViewModel: ObservableObject {
    @Published var description = ""
    @Published var image: UIImage?
    @Published var videoUrl: URL?
    @Published var isAnonymous = false
    @Published var isUploading = false
    @Published var selectedLocation: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    func submitIncidentBackend(completion: @escaping (Bool) -> Void) {
        guard let location = selectedLocation else {
            print("Локация не выбрана")
            completion(false)
            return
        }
        
        isUploading = true
        
        let url = "http://34.88.151.210:8080/api/incidents"
        
      
        let parameters: [String: String] = [
            "sender": "kymyz",
            "subject": description,
            "excerpt": description,
            "tags": "[\"срочно\", \"авария\"]",
            "latitude": "\(location.latitude)",
            "longitude": "\(location.longitude)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
       
            for (key, value) in parameters {
                if let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            
            if let image = self.image, let imageData = image.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData,
                                         withName: "media",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
            }
           
            else if let videoURL = self.videoUrl {
                multipartFormData.append(videoURL,
                                         withName: "media",
                                         fileName: "video.mov",
                                         mimeType: "video/quicktime")
            }
        }, to: url, method: .post, headers: HTTPHeaders([
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")"
        ]))
        .validate()
        .response { [weak self] response in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch response.result {
                case .success:
                    print("Инцидент успешно отправлен")
                    completion(true)
                case .failure(let error):
                    print("Ошибка отправки: \(error)")
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

}

