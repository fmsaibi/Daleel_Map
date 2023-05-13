//
//  SearchBar.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 9/10/21.
//

import UIKit
import NMAKit

extension MapVC: UISearchBarDelegate {
    
    func configureSearchBar(){
        
        let searchResultsController = searchResultTable()
        
        searchController = customSearchController(searchResultsController: searchResultsController)
        
        let searchBar = customSearchBar(searchBar: searchController.searchBar)
        
        customSearchBarView(searchBar: searchBar)

    }
    
    func searchResultTable() -> UIViewController {

        var table = UIViewController()
        
        if let  searchTable = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC {
            
            searchTable.delegate = self
            
            table = searchTable
            
        }
        
        return table
    }
    
    func customSearchBar(searchBar:UISearchBar) -> UISearchBar {
        
        searchBar.delegate = self
//        searchBar.placeholder
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.showsCancelButton = false
        return searchBar
    }
    
    func customSearchBarView(searchBar: UISearchBar){
        
        let searchView = UIView()
        
        searchView.backgroundColor = .white

//        if let width = navigationController?.navigationBar.frame.width,
//           let hight = navigationController?.navigationBar.frame.height {
//
//            searchView.frame.size = CGSize(width: width, height: hight)
//        }

        searchView.clipsToBounds = true

        searchView.addSubview(searchBar)

        self.navigationItem.titleView = searchView

        self.navigationItem.titleView?.roundedEdge(ClipsToBounds: true, radius: 20)

        let leading = searchBar.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0)

        let trailing = searchBar.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0)

        let top = searchBar.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 0)

        let bottom = searchBar.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 0)

        let constraint: [NSLayoutConstraint] = [top, bottom, leading, trailing]
        
        NSLayoutConstraint.activate(constraint)

        definesPresentationContext = true

    }
    
    func customSearchController(searchResultsController:UIViewController) -> UISearchController{
        
        let controller = UISearchController(searchResultsController: searchResultsController)
        
        controller.searchResultsUpdater = self

        controller.hidesNavigationBarDuringPresentation = false
        
        return controller
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

    }
    
    
}

extension MapVC : SearchResultDelegate {
    
    func searchViewDidSelectResult(_ result: MapData) {
        

        if let lat = result.lat, let lon = result.lon, let name = result.well, let area = result.ar{
            
            searchController.searchBar.text = name
            
            if let image = UIImage(named: "pointer_light") {
                
                myPostionBtn.setImage(image, for: .normal)

            }
            
            postionBtnEnable = false
            
            if mapView.zoomLevel <= Float(12) && markerHidden {

                self.markerHidden = false
                
                mapContainer.isVisible = true
                
            }
            
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.navigationBar.backgroundColor = .none
            
            getLocation(latitude: lat, longitude: lon, zoomlevel: 18, animation: .bow)
            
            
            if !self.informationViewAppear {
                
                self.positionPopupView(on: .bottom(parent: mapView, view: self.infromationView, bottomConstraint: 25, leftConstraint: 20, rightConstraint: 20))
                
                self.getDirectionBtn.roundedEdge(ClipsToBounds: true, radius: 20)
                        
                self.cancelBtn.roundedEdge(ClipsToBounds: true, radius: 20)
                

                self.infromationView.roundedEdge(ClipsToBounds: true, radius: 20)
                
                self.infromationView.shadow(offset: CGSize.init(width: 0, height: -5), color: .black, radius: 25, opacity: 0.1)
                
                //Mark:- Title View
                let cornerMask:CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                self.titleView.roundedEdge(ClipsToBounds: true, radius: 20, cornerMask: cornerMask)
                
                self.animateView(view: self.infromationView, option: .animateIn, duration: 0.2)
                
                self.informationViewAppear = true
            }
            
            self.wellName.text = "\(name) - \(area)"
            
            if result.typ != "" {
                
                if self.wellType.isHidden, self.wellTypeImg.isHidden  {
                    
                    self.wellType.isHidden = false
                    
                    self.wellTypeImg.isHidden = false
                    
                }
                
                self.wellType.text = result.typ
                
            } else {

                self.wellType.isHidden = true
                
                self.wellTypeImg.isHidden = true
                
            }
            
            switch result.h2s  {
            
            case "H":
                self.statusInfo.text = "High"
            case "M":
                self.statusInfo.text = "Medium"
            case "L":
                self.statusInfo.text = "Low"
            default:
                self.statusInfo.text = "Unknown"
            }
                
            if result.sm != "" {
                
                if self.smName.isHidden, self.smText.isHidden{
                    
                    self.smName.isHidden = false
                    
                    self.smText.isHidden = false
                }
                
                self.smName.text = result.sm
                
            } else {
                
                self.smName.isHidden = true
                
                self.smText.isHidden = true
                
                
            }
            
            calculatingRoute(self.userLocation, NMAGeoCoordinates(latitude: lat, longitude: lon)) { route in
                
                self.route = route
                
                if self.routeDidShow {
                    if let route = self.route, let box = route.boundingBox {
                        
                        self.setBoundingBox(boundingBox: box)
                        
                        self.createRoute(mapRoute: route)
                        
                    }
                }
                
                if let time = self.route?.ttaExcludingTraffic(forSubleg: UInt(NMARouteSublegWhole))?.duration{
                    
                    //infoView.time = TimeDecoding.secondToHHMM(time)
                    self.duration.text = TimeDecoding.secondToHHMM(time)

                }
            }
        }
    }
}

extension MapVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchVC  = searchController.searchResultsController as? SearchVC {
            
            
            searchVC.filterData = []
    
            if let text = searchController.searchBar.text, !text.isEmpty {
                
                self.navigationController?.navigationBar.backgroundColor = .white
                    
                for eachWell in mapData{
                        
                        searchVC.isFiltered = true
                        
                        if eachWell.well!.lowercased().contains(text.lowercased()){
                            
                            
                            searchVC.filterData.append(eachWell)
                            
                            searchVC.table.reloadData()
                            
                        } else {
                            

                            searchVC.table.reloadData()
                        }
                    }

            }else {
                    
                searchVC.isFiltered = false
                
                self.navigationController?.navigationBar.backgroundColor = .none
                
                searchVC.table.reloadData()
            }
        }
        
    }
    
}
