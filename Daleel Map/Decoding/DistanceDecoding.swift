//
//  DistanceDecoding.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 7/14/19.
//  Copyright © 2019 Fahad Al Khusaibi. All rights reserved.
//

import UIKit
/*
 *@note This to convert Dsitance to KM if the distance is Above 100 metters
 *@param Disntance in metters Distance should be of the type UInt
 *@retrun KM if the the distance above 100 and M if the distance is less then 100
 */
class DistanceDecoding: NSObject {
    
    static func meterToKm(_ distanceInMeter: UInt) -> String {
        
        var distance = String()
        
        if distanceInMeter >= 1000 {
            
            let distanceMeters = Measurement(value: Double(distanceInMeter), unit: UnitLength.meters)
            
            
            let km = distanceMeters.converted(to: UnitLength.kilometers)
            
            
            //Formate the value to 2 decimal with %.2f
            let formatted = String(format: "%.2f", km.value )
            
            if km.value <= 1000.00 {
                
                distance = "\(formatted) km"
            } else {
                distance = " km"
            }
            
        } else {

            distance = "\(distanceInMeter) m"
        }
        
        return distance
    }

}


