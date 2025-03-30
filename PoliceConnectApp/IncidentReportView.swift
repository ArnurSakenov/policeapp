//
//  IncidentReportView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 28.03.2025.
//

import SwiftUI
import PhotosUI

struct IncidentReportView: View {
    @StateObject private var viewModel = IncidentViewModel()
    @State private var photoItem: PhotosPickerItem?
    @State private var showingCameraImagePicker = false
    @State private var showingCameraVideoPicker = false
    @State private var showingLocationPicker = false  

    var body: some View {
        NavigationStack {
            Form {
                Section("Описание происшествия") {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 150)
                }
                
                Section("Медиа") {
                    // Выбор из галереи: фото или видео
                    PhotosPicker(selection: $photoItem, matching: .any(of: [.images, .videos])) {
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else if viewModel.videoUrl != nil {
                            Text("Видео выбрано")
                        } else {
                            Label("Выбрать медиа из галереи", systemImage: "photo.on.rectangle")
                        }
                    }
                    .onChange(of: photoItem) { newItem in
                        Task {
                            // Здесь для простоты обрабатываем только фото; можно расширить логику для видео.
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                viewModel.image = uiImage
                                viewModel.videoUrl = nil
                            }
                        }
                    }
                    
                    // Кнопки для камеры
                    HStack {
                        Button(action: {
                            showingCameraImagePicker = true
                        }) {
                            Label("Снять фото", systemImage: "camera")
                        }
                        .sheet(isPresented: $showingCameraImagePicker) {
                            MediaPicker(sourceType: .camera,
                                        mediaTypes: ["public.image"]) { image, videoURL in
                                if let image = image {
                                    viewModel.image = image
                                    viewModel.videoUrl = nil
                                }
                            }
                        }
                        
                        Button(action: {
                            showingCameraVideoPicker = true
                        }) {
                            Label("Записать видео", systemImage: "video")
                        }
                        .sheet(isPresented: $showingCameraVideoPicker) {
                            MediaPicker(sourceType: .camera,
                                        mediaTypes: ["public.movie"]) { image, videoURL in
                                if let videoURL = videoURL {
                                    viewModel.videoUrl = videoURL
                                    viewModel.image = nil
                                }
                            }
                        }
                    }
                }
                
                Section("Геолокация") {
                    if let location = viewModel.selectedLocation {
                        Text("Выбрано: \(location.latitude.rounded(toPlaces: 4)), \(location.longitude.rounded(toPlaces: 4))")
                    } else {
                        Text("Локация не выбрана")
                    }
                    Button("Выбрать локацию") {
                        showingLocationPicker = true
                    }
                }
                .sheet(isPresented: $showingLocationPicker) {
                    NavigationStack {
                        LocationPickerView { coordinate in
                            viewModel.selectedLocation = coordinate
                        }
                    }
                }
                
                Section {
                    Toggle("Отправить анонимно", isOn: $viewModel.isAnonymous)
                }
                
                Section {
                    Button {
                        // Вызываем новый метод отправки на backend
                        viewModel.submitIncidentBackend { success in
                            if success {
                                viewModel.description = ""
                                viewModel.image = nil
                                viewModel.videoUrl = nil
                                viewModel.selectedLocation = nil
                                viewModel.isAnonymous = false
                            }
                        }
                    } label: {
                        if viewModel.isUploading {
                            ProgressView()
                        } else {
                            Text("Отправить")
                        }
                    }
                    .disabled(viewModel.description.isEmpty || viewModel.isUploading)
                }

            }
            .navigationTitle("Сообщить")
        }
    }
}
