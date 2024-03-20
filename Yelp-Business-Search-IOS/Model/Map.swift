//
//  Map.swift
//
//  Created by Kiara Lei on 12/3/22.
//

import SwiftUI
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

class MapModel : ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0898, longitude: 118.3215), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var place : IdentifiablePlace = IdentifiablePlace(id: UUID(), lat: 34, long: 118)
    
    func getMap(result : Result){
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.place = IdentifiablePlace(id: UUID(), lat: result.latitude, long: result.longitude)
    }
    
}


