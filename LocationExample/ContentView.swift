//
//  ContentView.swift
//  LocationExample
//
//  Created by Gabriel Estévez López on 4/16/24.
//

import SwiftUI

import MapKit

struct ContentView: View {
    
    @StateObject var manager = LocationManager()
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
