//
//  JSON.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 2/22/21.
//

import Foundation
import UIKit


class JSON: NSObject {
    
    static let shared = JSON()
    
    //MARK:- Reading Load File
    static func readFrom(LocalFile: String) -> Data? {
            do {
                if let bundlePath = Bundle.main.path(forResource: LocalFile, ofType: "json"),
                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    
                    return jsonData
                    
                }
                
            } catch {
                
                print("Error: No File Found")
                
            }
            
            return nil
        }
    
    //MARK:- Parsing JSON File.
    static func decodedData(jsonFile: Data) -> [MapData]? {
            do {

                let jsonDecoder = try JSONDecoder().decode([MapData].self, from: jsonFile)
                
                return jsonDecoder

            } catch {
                
                print("Error: Could not decode the file, Please call the Admin")
                
            }
            return nil
        }
        
    
    
}


struct MapData: Codable {
    let well: String?
    let ar: String?
    let lon: Double?
    let lat: Double?
    let typ: String?
    let sm: String?
    let h2s: String?
}
