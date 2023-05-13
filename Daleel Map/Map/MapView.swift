//
//  MapView.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 2/20/21.
//

import Foundation
import NMAKit.NMAMapView


extension MapVC: NMAMapViewDelegate {
    
    func configureMapViewDelegate(){
        
        mapView.delegate = self
        
        mapView.copyrightLogoPosition = .bottomRight//Set Here Map Copy Right Logo
        
        mapView.mapScheme = NMAMapSchemeHybridDay
        
        mapView.twoFingerPanTiltingEnabled = false
        
        mapView.gestureDelegate = self
        
        mapView.zoomLevel = 18

        
    }
    
    
    
    func mapView(_ mapView: NMAMapView, didSelect objects: [NMAViewObject]) {
        
        if let obj = objects.first, let lab = obj.accessibilityLabel {
            for eachWell in mapData {
                if lab == eachWell.well {
                    if routeDidShow {
                        
                        removeRoute()
                        
                        route = nil
                        
                    }
                    
                    searchViewDidSelectResult(eachWell)
                }
            }
        }
    }
    
    
    //Mark:- Diable postion Trucking when moving 
    func mapViewDidBeginMovement(_ mapView: NMAMapView) {
        
        if postionBtnEnable {
            
            postionBtnEnable = false
            
            if onTrip {
                
                navigationManager.mapTrackingEnabled = false
                
            }
            
            if let image = UIImage(named: "pointer_light") {
                
                myPostionBtn.setImage(image, for: .normal)
            }
            
        }
    }
}

extension MapVC: NMAMapGestureDelegate {
    
    func mapView(_ mapView: NMAMapView, didReceivePinch pinch: Float, at location: CGPoint) {
        
        mapView.defaultGestureHandler?.mapView?(mapView, didReceivePinch: pinch, at: location)
        
        if mapView.zoomLevel <= Float(12) && !markerHidden{
            
            mapContainer.isVisible = false
            
            self.markerHidden = true
            
        }
        
        if mapView.zoomLevel >= Float(12) && markerHidden {

            self.markerHidden = false
            
            mapContainer.isVisible = true
            
        }
    }
    
}

