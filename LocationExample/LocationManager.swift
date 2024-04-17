//
//  LocationManager.swift
//  LocationExample
//
//  Created by Gabriel Estévez López on 4/16/24.
//

import Foundation
import MapKit
import _MapKit_SwiftUI //Esto seguro tengo q ponerlo solo yo porque debo tener un SDK viejo, pero normalmente todo funciona en con MapKit

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    var location = CLLocation()
    var region = MKCoordinateRegion(
        center: .init(latitude: 55.334_900, longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    ///Este parametro lo puse simplemente para cumplir con el constructor de map
    var mapCameraPosition : MapCameraPosition
    
    override init() {
        mapCameraPosition = .automatic
//        mapCameraPosition = .region(region) // se puede definir la posicion inicial de varias maneras, con .automatico o con la region que tienes por default, esto se ve principalmente cuando instalas la app por primera vez, porque luego cuando abres la app en otras ocaciones cuando ya está instalada, pues no logras ver la region inicial porque se actualiza muy rapido el location 😂
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
            //If we are authorized then we request location just once, to center the map
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            //If we don´t, we request authorization
        case .notDetermined:
//            locationManager.startUpdatingLocation() //Hay que solicitar autorizacion en este caso, asi que esto no funciona aqui.
            locationManager.requestWhenInUseAuthorization()
            
        default: // Aqui quizas se pudiera tambien solicitar autorizacion o simplificar el .notDetermined dentro del default.
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        //Aqui era necesario cambiarlo por esto para que al instalar la app por primera vez comenzara a actualizar la posicion.
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        locationManager.startUpdatingLocation() //Esto no hace falta llamarlo de nuevo.
        //locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        self.location = location
        debugPrint("location: \(location)")
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
//        self.mapCameraPosition = .region(region) // Esta es una variante usando la region
        
        //Esta otra usando camera, puedes definirle dos parametros mas a camera, que son heading y pitch
        let mapCamera = MapCamera(centerCoordinate: location.coordinate, distance: 900)
//        self.mapCameraPosition = .camera(mapCamera)
        
        
        //Para la posicion del usuario
        
        //Aqui se puede jugar con varias configuraciones
        if mapCameraPosition.positionedByUser {
            debugPrint("position positionedByUser")
            self.mapCameraPosition = .userLocation(fallback: .camera(mapCamera))
            
        } else { //Esto es un intento de forzar volver a centrar el mapa donde está el usuario , pero no lo tengo muy claro. 
            debugPrint("position fallback userLocation automatic")
            self.mapCameraPosition = .userLocation(fallback: .region(region))
        }
    }
    //        locations.last.map {
    //            region = MKCoordinateRegion(
    //                center: $0.coordinate,
    //                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    //            )
    //        }
    //  }
}
