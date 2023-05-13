//
//  DataSource.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 4/14/21.
//

import Foundation

extension MapVC {
    
    //Mark:- Reading JSON File
    func  loadData(_ fileName: String) -> [MapData]?{
        
        guard let file = JSON.readFrom(LocalFile: fileName), let decodeFile = JSON.decodedData(jsonFile: file) else { return [] }
        
        return decodeFile
    }
    
    
    func loadMarker(){
        if !mapData.isEmpty {
            for eachWell in mapData{
                
                if let lat  = eachWell.lat, let lon = eachWell.lon, let lable = eachWell.well{

                    
                    Marker.addImage(mapView, mapContainer, lable, lat, lon, displayImage: textImage(text: lable), false)
                }
            }
        }
    }
    
    
    
}
