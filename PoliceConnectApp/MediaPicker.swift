//
//  MediaPicker.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//

import SwiftUI

struct MediaPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var mediaTypes: [String]
    var completion: (UIImage?, URL?) -> Void

    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = mediaTypes
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
            if let image = info[.originalImage] as? UIImage {
                parent.completion(image, nil)
            }
           
            else if let videoURL = info[.mediaURL] as? URL {
                parent.completion(nil, videoURL)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
