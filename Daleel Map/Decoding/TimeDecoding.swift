//
//  TimeDecoding.swift
//  Naaqal
//
//  Created by Fahad Al Khusaibi on 7/14/19.
//  Copyright © 2019 Fahad Al Khusaibi. All rights reserved.
//

import UIKit

/*
 *@note This to convert time from second to HH:MM:SS
 *@param TimeInterval
 *@retrun Time in HH:MM:SS
 */
class TimeDecoding: NSObject {
    
    static func secondToHHMMSS(_ timeInterval:TimeInterval) -> String {
        var hhmmss = String()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .dropAll ]
        
        if let formattedTime = formatter.string(from: timeInterval) {
            hhmmss = formattedTime
        }

        return hhmmss
    }
    
    static func secondToHHMM(_ timeInterval:TimeInterval) -> String {
        var hhmm = String()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = [ .dropAll ]
        
        if let formattedTime = formatter.string(from: timeInterval) {
            hhmm = formattedTime
        }

        return hhmm
    }

}
