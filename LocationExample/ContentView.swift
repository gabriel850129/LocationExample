//
//  ContentView.swift
//  LocationExample
//
//  Created by Gabriel Estévez López on 4/16/24.
//

import SwiftUI

import MapKit

struct ContentView: View {
    
//    @StateObject var manager = LocationManager() //StateObject es viejo, no uses esto
    @State var manager = LocationManager()
    
    var body: some View {
        //Este Constructor está deprecado
//        Map(coordinateRegion: $manager.region, showsUserLocation: true)
        
        //Este otro constructor es uno de los que no está deprecado, pero hay varios
        Map(position: $manager.mapCameraPosition, interactionModes: .all)
        
//            .edgesIgnoringSafeArea(.all) //No es necesario con el nuevo tipo de mapa, porque ya ingorea toda el area.
    }
}

#Preview {
    ContentView()
}
