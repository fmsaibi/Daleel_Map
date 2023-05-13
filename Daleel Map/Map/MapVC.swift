//
//  MapVC.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 2/16/21.
//

import UIKit
import NMAKit
import CoreLocation

 
class MapVC: UIViewController{

    var useSimulater =  true //To Be Deleted on production
    
    var positioningManager = NMAPositioningManager.sharedInstance()//To Be Deleted
    
    let locationManager = CLLocationManager()
    
    var mapData:[MapData]!
    
    let mapContainer = NMAMapContainer()//Store all Marker in the continer
    
    let coreRouter = NMACoreRouter() // Calculating request to return a route  that can't be followed
    
    var mapRoute = [NMAMapRoute]()//Store Map Route Object
    
    var route : NMARoute?
    
    var userLocation = NMAGeoCoordinates()

    var searchController:UISearchController!
    
    //voice and visual instructions while driving.
    lazy var navigationManager = NMANavigationManager.sharedInstance()
    
    var postionBtnEnable = true
    
    var onTrip = false
    
    var markerHidden = false
    
    var routeDidShow = false
    
    var informationViewAppear = false
    
   
    var mapLoader: NMAMapLoader! /////////////////////////////////////////////// map Loader //////////////////////
    
    var unistallMap = false
    
    @IBOutlet var navigationTopBar: UIView!
    
    @IBOutlet var navigationTitle: UILabel!
    
    @IBOutlet var myPostionBtn: UIButton!
    
    @IBOutlet var mschemesBtn: UIButton!
    
    @IBOutlet var mapView: NMAMapView!
    
    @IBOutlet var titleView: UIView!
    
    @IBOutlet var infromationView: UIView!
    
    @IBOutlet var wellName: UILabel!
    
    @IBOutlet var smName: UILabel!
    
    @IBOutlet var smImg: UIImageView!
    @IBOutlet var smText: UITextField!
    
    @IBOutlet var duration: UILabel!
    
    @IBOutlet var durationImg: UIImageView!
    
    @IBOutlet var wellType: UILabel!
    
    @IBOutlet var wellTypeImg: UIImageView!
    
    @IBOutlet var statusInfo: UILabel!
    
    @IBOutlet var statusImg: UIImageView!
    
    @IBOutlet var getDirectionBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var navigationDashboard: UIStackView!
    
    @IBOutlet var navigationCancelBtn: UIButton!
    
    @IBOutlet var tripDistance: UILabel!
    
    @IBOutlet var tripDuration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

        configureSearchBar()
        
        configureNavigationBar()
        
        configureMapViewDelegate()
        
        configureLocationManagerDelegate()
        
        configureNavigationSetup()
        
        configureMaploader()
        
        if let data = loadData("dll_well_ coordinate_aug21"), !data.isEmpty {
            
            mapData = data

        } else {
            
            print("Couldnt find file")
        }
        
//        mapData = loadData("dll_well_ coordinate_aug21")
        
        loadMarker()
        
        
        if useSimulater {
            
            home()
            
        }
        

    }
    


    @IBAction func positionBtnAction(_ sender: Any) {
        
        
        if postionBtnEnable {

            
            if let image = UIImage(named: "pointer_light") {
                
                
                myPostionBtn.setImage(image, for: .normal)
                
                
                postionBtnEnable = false
                
                if onTrip {
                    
                    navigationManager.mapTrackingEnabled = false //follow your position during guidance
                    
                }

            }

        } else {


            if let image = UIImage(named: "pointer_light_fill") {
                
                myPostionBtn.setImage(image, for: .normal)
                
                postionBtnEnable = true
                
                
                if onTrip {

                    
                    navigationManager.mapTrackingEnabled = true //follow your position during guidance
                    

                } else {
                    

                    if useSimulater {
                        
                        didUpdatePosition()
                        
                    } else {
                        
                        self.mapView.set(geoCenter: self.userLocation, zoomLevel: 18, animation: .linear)
                    }
                }
                
                if mapView.zoomLevel < 16, markerHidden  {
                    
                    mapContainer.isVisible = true
                }
                
            }
        }
    }
    
    @IBAction func schemesBtn(_ sender: Any) {
        
        let schemeVC = storyboard?.instantiateViewController(withIdentifier: "MapSchemeVC") as! MapSchemeVC

        schemeVC.delegate = self

        schemeVC.currentScheme = mapView.mapScheme


        schemeVC.modalPresentationStyle = .overCurrentContext

        self.present(schemeVC, animated:true, completion:nil)

        
    }
    
    @IBAction func getDirectionBtnClick(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        if !routeDidShow {
            
            
            if let route = self.route, let box = route.boundingBox {
                
                setBoundingBox(boundingBox: box)
                
                createRoute(mapRoute: route)
                
            }
            
            getDirectionBtn.setTitle("Start", for: .normal)
            
            routeDidShow = true
            
        } else {
            
            animateView(view: infromationView, option: .animateOut, duration: 0.2)
            
            mschemesBtn.isHidden = true
            
            self.informationViewAppear = false
            
            getDirectionBtn.setTitle("Show", for: .normal)
            
            //Dashboard
            positionPopupView(on: .bottom(parent: mapView, view: navigationDashboard, bottomConstraint: 0, leftConstraint: 0, rightConstraint: 0))
            
            animateView(view: navigationDashboard, option: .BottomToTop(removeFromView: false), duration: 0.2)
            
//            //Top Bar
//            positionPopupView(on: .top(parent: mapView, view: navigationTopBar, topConstraint: 0, leftConstraint: 0, rightConstraint: 0))
//            
//            animateView(view: navigationTopBar, option: .TopToBottom(removeFromView: false), duration: 0.2)
            
            
            startNavigation()
            
            let timeToArrival = navigationManager.timeToArrival
            
            let distance =  navigationManager.distanceToDestination
                            
            let currentDateTime = Date().addingTimeInterval(timeToArrival)
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            let arrivingTime = formatter.string(from: currentDateTime)

            
            tripDistance.text = " \(TimeDecoding.secondToHHMMSS(timeToArrival))"
            
            tripDuration.text = "\(DistanceDecoding.meterToKm(UInt(distance))) | \(arrivingTime)"
            
            positionBtnAction(self)
            
            
        }
        
    }
    
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        
        removeRoute()
        
        self.route = nil
        
        routeDidShow = false
        
        informationViewAppear = false
        
        animateView(view: infromationView, option: .animateOut, duration: 0.2)
        
        getDirectionBtn.setTitle("Show", for: .normal)
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.backgroundColor = .none
        
    }
    
    @IBAction func tripCancelBtnClick(_ sender: Any) {
        
        stopNavigation()
        
        mschemesBtn.isHidden = false
        

    }
    
}
