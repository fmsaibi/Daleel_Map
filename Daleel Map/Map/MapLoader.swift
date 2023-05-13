//
//  MapLoader.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 9/12/21.
//

import Foundation

import NMAKit


extension MapVC: NMAMapLoaderDelegate {
    
    func configureMaploader() {

        // Instantiate a MapLoader
        self.mapLoader = NMAMapLoader.sharedInstance()
        
        self.mapLoader.delegate = self
        
        // Obtain the current state of the map package hierachies.
        self.mapLoader.getMapPackage(at: NMAGeoCoordinates(latitude: 23.5825735, longitude: 58.1443239))
        

    }
    
    
    
    func mapLoader(_ mapLoader: NMAMapLoader, didGetMap package: NMAMapPackage?, at coordinates: NMAGeoCoordinates, _ mapLoaderResult: NMAMapLoaderResult) {
        
        switch mapLoaderResult {

        case .success:
            
            if let status = package {
                
                switch status.installationStatus {
  
                case .none, .partiallyInstalled:
                    print("Not Installed")
                    
                    let success = self.mapLoader.install([status])
                    
                    if !success {
                    
                        print("MapLoader is being busy with other operations")
                    
                    } else {
                        
                        let size = Int(status.sizeOnDisk)
                        
                        if size > 1024 {
                            
                            print("Instaltion Size = \(size / 1024) MB")
                            
                        } else {
                            
                            print("Instaltion Size = \(size) KB")
                        }
                    
                        print("Installing...")
                    }
                
                case .implicit, .explicit:
                    
                    if unistallMap {
                        let success = self.mapLoader.uninstall([status])
                        
                        if !success {
                            
                            print("MapLoader is being busy with other operations")
                            
                        } else {
                            
                            print("Uninstalling...")
                            
                        }
                    }
                    
                @unknown default:
                    break
                }
            }
            
        case .invalidParameters:
            print("Invalid")
            
        case .operationCancelled:
            print("Got Cancel")
            
        case .initializationFailed:
            print("Failed to initialize")
            
        case .connectionFailed:
            print("Connection Failed")
            
        case .searchFailed:
            print("Search Failed")
            
        case .insufficientStorage:
            print("insufficient Storage, please empty your phone stroage")
            
        @unknown default:
            break
        }
    }
//
 
    func mapLoader(_ mapLoader: NMAMapLoader,
                   didInstallPackages mapLoaderResult: NMAMapLoaderResult) {

        if mapLoaderResult == .success {
            
            print("Installation Succseful")
            
        } else if mapLoaderResult == .operationCancelled {
            
            print("Installation is cancelled...")
        }
    }
    
    func mapLoader(_ mapLoader: NMAMapLoader,
                   didUninstallPackages mapLoaderResult: NMAMapLoaderResult) {
        
        if mapLoaderResult == .success {
            
            print("Successful uninstallation")
            
        } else if mapLoaderResult == .operationCancelled {
            
            print("Uninstallation is cancelled...")
        }
    }
    
    func mapLoader(_ mapLoader: NMAMapLoader, didUpdate progress: Float) {
        if progress < 1.0 {
            
            print("Progress: \(progress * 100)%")
            
        } else {
            
           print("Finished")
        }
    }
    
    func mapLoader(_ mapLoader: NMAMapLoader, didFindUpdate updateIsAvailable: Bool, from currentMapVersion: String, to newestMapVersion: String, _ mapLoaderResult: NMAMapLoaderResult) {
        
        if mapLoaderResult == .success {
            
            if updateIsAvailable {
                // Update map if there is a new version available
                print("Found new map version %@ \(newestMapVersion)")
                
                let success = self.mapLoader.performMapDataUpdate()
                
                if !success {
                    
                    print("MapLoader is being busy with other operations")
                }
                
            } else {
                
                print("Current map version %@ is the latest.\(currentMapVersion)")
            }
        }
    }
}
