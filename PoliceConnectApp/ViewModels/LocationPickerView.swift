//
//  LocationPickerView.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//
import SwiftUI
import MapKit
import CoreLocation
struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.169392, longitude: 71.449074), 
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var onLocationSelected: (CLLocationCoordinate2D) -> Void

    var body: some View {
        VStack {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: selectedCoordinate != nil ? [selectedCoordinate!] : []) { coordinate in
              
                MapPin(coordinate: coordinate)
            }
            .frame(height: 300)
            .onTapGesture {
                
                selectedCoordinate = region.center
            }
            .cornerRadius(12)
            .padding()

            if let coordinate = selectedCoordinate {
                Text("Выбрано: \(coordinate.latitude.rounded(toPlaces: 4)), \(coordinate.longitude.rounded(toPlaces: 4))")
                    .padding()
            } else {
                Text("Нажмите на карту, чтобы выбрать точку")
                    .padding()
            }

            Button("Выбрать эту локацию") {
                if let coordinate = selectedCoordinate {
                    onLocationSelected(coordinate)
                    dismiss()
                }
            }
            .padding()
            .disabled(selectedCoordinate == nil)

            Spacer()
        }
        .navigationTitle("Выбрать локацию")
    }
}


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude),\(longitude)"
    }
}
