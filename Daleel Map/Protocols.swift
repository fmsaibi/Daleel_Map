//
//  Protocols.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 4/27/21.
//

import Foundation
import NMAKit.NMAMapView

protocol SearchResultDelegate {
    
    func searchViewDidSelectResult(_ result: MapData)
}


protocol MapSchemeDelegate  {
    
    func mapViewDidChangeScheme(_ mapScheme: String)
}


