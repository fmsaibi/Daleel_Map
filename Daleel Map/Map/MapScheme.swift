//
//  MapScheme.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 9/10/21.
//

import Foundation

//Mark:- Change the Scheme of the map
extension MapVC: MapSchemeDelegate {
    
    func mapViewDidChangeScheme(_ mapScheme: String) {
        
        if !mapScheme.isEmpty {
            
            mapView.mapScheme = mapScheme

        }
    }
}
