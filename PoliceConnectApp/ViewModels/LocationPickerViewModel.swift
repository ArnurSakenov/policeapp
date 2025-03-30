//
//  LocationPickerViewModel.swift
//  PoliceConnectApp
//
//  Created by Arnur Sakenov on 30.03.2025.
//

import SwiftUI
import CoreLocation

class LocationPickerViewModel: NSObject, ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                reverseGeocode(coordinate: coordinate)
            }
        }
    }
    
    @Published var addressString: String = ""
    
    private let geocoder = CLGeocoder()
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  let placemark = placemarks?.first,
                  error == nil else {
                DispatchQueue.main.async {
                    self?.addressString = "Не удалось определить адрес"
                }
                return
            }
            
           
            let streetName = placemark.thoroughfare ?? ""
            let streetNumber = placemark.subThoroughfare ?? ""
            let city = placemark.locality ?? ""
            let country = placemark.country ?? ""
          
            let fullAddress = [streetName, streetNumber, city, country]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
            
            DispatchQueue.main.async {
                self.addressString = fullAddress
            }
        }
    }
}
