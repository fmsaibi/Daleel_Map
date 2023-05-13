//
//  MapRoute.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 5/26/21.
//

import Foundation
import NMAKit
extension MapVC {
    
    

    //MARK:-  Calculating Routefrom Start Point to End
    func calculatingRoute(_ start:NMAGeoCoordinates , _ end:NMAGeoCoordinates, completion:@escaping (NMARoute) -> () ){
        
        /**
         * Constructs NMAGeoCoordinates with latitude & longitude
         * to be able to read by NMACoreRouter
         */
        
        let waypoints = [start, end]
        
        /**
         * Creating Routing Mode Options
         */
        let routingMode = NMARoutingMode(routingType: .fastest, transportMode: .car, routingOptions: .avoidBoatFerry)
        
        
        let dynamicPenalty = NMADynamicPenalty()
        
        
        
        coreRouter.dynamicPenalty = dynamicPenalty
            
        _ = coreRouter.calculateRoute(withStops: waypoints, routingMode: routingMode, { (data, error) in
            
            
            if let data = data, let routes = data.routes, let route = routes.first {
            
                
                completion(route)
                
            }
            
        })?.resume()
        
    }


    // MARK:- Shape of a route  path that can be displayed on a map.
    func createRoute(mapRoute:NMARoute){
        
        if let mapObject = NMAMapRoute(mapRoute) {
            
            mapObject.color = .blue
            mapObject.traveledColor = .clear
            mapObject.outlineColor = .clear

       
            self.mapRoute.append(mapObject)
       
            self.mapView.add(mapObject: mapObject)
            
        }
    }


    
    // MARK: - Remove all routes from mapView.
    func removeRoute() {
        
        if self.mapRoute.count != 0 {
            for routeObject in self.mapRoute {
                
                self.mapView.remove(mapObject: routeObject)
                
            }
            
            self.mapRoute.removeAll()
        }
    }
    
    
    //Mark:- BoundingBox that contains the entire `NMARoute
    func setBoundingBox(boundingBox: NMAGeoBoundingBox) {
        
        let resizePoints:Double = 8/1000

        let customBox = NMAGeoBoundingBox()
        
        
        customBox.topLeft = .init(latitude: boundingBox.topLeft.latitude + resizePoints, longitude: boundingBox.topLeft.longitude - resizePoints)
        
        customBox.bottomRight = .init(latitude: boundingBox.bottomRight.latitude - resizePoints, longitude: boundingBox.bottomRight.longitude + resizePoints)
        
        mapView.set(boundingBox: customBox, animation: .bow)
        
            
    }
}
