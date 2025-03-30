//
//  ShakeDetectingView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI


struct ShakeDetectingView<Content: View>: UIViewControllerRepresentable {
    @Binding var isShaken: Bool
    let content: () -> Content

    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let hostingController = ShakeHostingController(rootView: content())
        hostingController.shakeHandler = {
            
            self.isShaken = true
        }
        return hostingController
    }

    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content()
    }
}


class ShakeHostingController<Content: View>: UIHostingController<Content> {
    var shakeHandler: (() -> Void)?
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            shakeHandler?()
        }
    }
}
