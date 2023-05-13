//
//  MapSchemeVC.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 5/1/21.
//

import UIKit
import NMAKit.NMAMapView

class MapSchemeVC: UIViewController {

    var delegate: MapSchemeDelegate!
    
    var currentScheme = String()
        
    @IBOutlet var titleView: UIView!
    @IBOutlet var mapSchemeView: UIView!
    @IBOutlet var normalBtn: UIButton!
    @IBOutlet var normalBtnView: UIView!
    @IBOutlet var sateliteBtn: UIButton!
    @IBOutlet var sateliteBtnView: UIView!
    @IBOutlet var terrainBtn: UIButton!
    @IBOutlet var terrainBtnView: UIView!
    @IBOutlet var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    enum SchemeType: String {
        case normal = "normal.day.transit"
        case satelite = "hybrid.day"
        case terrain = "terrain.day"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        self.view.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer()
        
        tap.delegate = self
        
        self.view.addGestureRecognizer(tap)
        
        self.view.accessibilityIdentifier = "mainView"
        
        customizableScheme()
        
        switch SchemeType(rawValue: currentScheme) {
        
        case .normal:
            normalBtnView.backgroundColor = .green
            
        case .satelite:
            sateliteBtnView.backgroundColor = .green
            
        case .terrain:
            terrainBtnView.backgroundColor = .green
            
        case .none:
            print("Error")
        }
    }
    
    
    @IBAction func normalBtnPress(_ sender: UIButton) {
        
        highLightButton(normal: .green, satelite: .white, terrain: .white)

        if let mapScheme = self.delegate {
            
            
            mapScheme.mapViewDidChangeScheme(NMAMapSchemeNormalDayTransit)
            
        }
        
    }
    
    @IBAction func satelliteBtnPress(_ sender: UIButton) {
        
        highLightButton(normal: .white, satelite: .green, terrain: .white)
        
        if let mapScheme = self.delegate {
            
            
            mapScheme.mapViewDidChangeScheme(NMAMapSchemeHybridDay)
            
        }
        
    }
    
    @IBAction func terrainBtnPress(_ sender: UIButton) {
        
        highLightButton(normal: .white, satelite: .white, terrain: .green)

        if let mapScheme = self.delegate {
            
            
            mapScheme.mapViewDidChangeScheme(NMAMapSchemeTerrainDay)
            
        }
        
    }
    
    @IBAction func doneBtnPress(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //Mark:- customize the corner of the view
    
    func customizableScheme(){
                
        //Mark:- Button
        normalBtn.roundedEdge(ClipsToBounds: true, radius: 8)
        
        sateliteBtn.roundedEdge(ClipsToBounds: true, radius: 8)

        terrainBtn.roundedEdge(ClipsToBounds: true, radius: 8)
        
        doneBtn.roundedEdge(ClipsToBounds: true, radius: 20)
        
        //Mark:- Button View
        normalBtnView.roundedEdge(ClipsToBounds: true, radius: 8)
        
        sateliteBtnView.roundedEdge(ClipsToBounds: true, radius: 8)

        terrainBtnView.roundedEdge(ClipsToBounds: true, radius: 8)
        
        //Mark:- Scheme View
        mapSchemeView.roundedEdge(ClipsToBounds: true, radius: 25)
        
        mapSchemeView.shadow(offset: CGSize.init(width: 0, height: -5), color: .black, radius: 25, opacity: 0.1)
        
        //Mark:- Title View
        let cornerMask:CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        titleView.roundedEdge(ClipsToBounds: true, radius: 25, cornerMask: cornerMask)
        
    }
    
    
    func highLightButton(normal:UIColor,satelite:UIColor,terrain:UIColor ){
        
        normalBtnView.backgroundColor = normal
        
        sateliteBtnView.backgroundColor = satelite
        
        terrainBtnView.backgroundColor = terrain
        
    }
    
}

extension MapSchemeVC: UIGestureRecognizerDelegate{


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let type = touch.view?.accessibilityIdentifier

        if type == "mainView" {
            
            self.dismiss(animated: true, completion: nil)
            
            return true
            
        } else {
            
            return false
        }
    }

}


