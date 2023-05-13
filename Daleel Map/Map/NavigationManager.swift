//
//  NavigationManager.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 6/10/21.
//

import Foundation
import NMAKit

//MARK:- Navigiating
extension MapVC: NMANavigationManagerDelegate {


    func configureNavigationSetup(){
        
        navigationManager.delegate = self // Let NavigationManager Delegateso that it can listening to the
        
        navigationManager.map = mapView //launch navigation on current mapView
    
    }
    
    
    func startNavigation(){
        
        onTrip = true
        /*
        if let img = UIImage(named: "car_icon_dark_mini") {
            
        
            let imageIcon = NMAImage(uiImage:img)//Add Image to a Marker
            
            
            let mapMarker = NMAMapMarker()
            
            mapMarker.icon = imageIcon
            
            mapView.positionIndicator.displayObject = mapMarker
            
        }
        */
        
        if let routeValue = self.route {
            
            
            //MARK:- Navigation Simulater - Need to be removed
            if useSimulater {
                let source = NMARoutePositionSource(route: routeValue)
                
                source.movementSpeed = 90
                
                positioningManager.dataSource = source
            }
            
            mapView.transformCenter = CGPoint(x: 0.5, y: 0.80) //Position location at the bottom
            
            navigationManager.startTurnByTurnNavigation(routeValue) //Start
            
            
        
            
            UIApplication.shared.isIdleTimerDisabled = true

            
            
        } else {
            
            print("Warn the user on how to enable location serivce")
        }
    }
    
    func stopNavigation() {
        
        
        navigationManager.stop()// Stop voice and visual instructions while driving.

        navigationManager.mapTrackingEnabled = false // follow your position during guidance

        navigationManager.mapTrackingAutoZoomEnabled = false //zoom to proper zoomlevel during guidance automatically
        
        mapView.tilt = .zero

        if useSimulater {

            positioningManager.dataSource = nil

        }
        
        removeRoute()
        
        onTrip = false
        
        routeDidShow = false
    
        route = nil
    
        mapView.transformCenter = CGPoint(x: 0.5, y: 0.5)
        
        animateView(view: navigationDashboard, option: .TopToBottom(removeFromView: true),
                    duration: 0.2 )
        
//        animateView(view: navigationTopBar, option: .BottomToTop(removeFromView: true),
//                    duration: 0.2 )
//
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.navigationBar.backgroundColor = .none
        }
        

        
        if let img = UIImage(named: "Position") {
            
            let imageIcon = NMAImage(uiImage:img)//Add Image to a Marker
            
            
            let mapMarker = NMAMapMarker()
            
            mapMarker.icon = imageIcon
            
            mapView.positionIndicator.displayObject = mapMarker
            
        }
        
        
        postionBtnEnable = true
        
        if let image = UIImage(named: "pointer_light_fill") {
            
            myPostionBtn.setImage(image, for: .normal)
            
        }
        
        UIApplication.shared.isIdleTimerDisabled = false
        
    }
    
    
    func navigationManagerDidReachDestination(_ navigationManager: NMANavigationManager) {
        
        stopNavigation()
        
        mschemesBtn.isHidden = false
        
    }
    
    func navigationManagerDidLosePosition(_ navigationManager: NMANavigationManager) {
        
        print("navigationManagerDidLosePosition")
        
    }
    func navigationManagerDidFindPosition(_ navigationManager: NMANavigationManager) {
        
    }
    
    func navigationManagerWillReroute(_ navigationManager: NMANavigationManager) {
        
        removeRoute()
        
        print("navigationManagerWillReroute")
        
        
    }
    /**
     * @note recalcaute new route if the driver has miss the trun
     */

    
    func navigationManager(_ navigationManager: NMANavigationManager, didUpdateRoute routeResult: NMARouteResult) {
        if let routes = routeResult.routes, let route = routes.first {
            
            self.route = route
            
            createRoute(mapRoute: route)
            
        }
    }
    
    func navigationManager(_ navigationManager: NMANavigationManager, didUpdateManeuvers currentManeuver: NMAManeuver?, _ nextManeuver: NMAManeuver?) {
    }
    
}



