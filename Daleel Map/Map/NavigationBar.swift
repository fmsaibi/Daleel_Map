//
//  NavigationBar.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 9/10/21.
//

import Foundation

import UIKit.UIImage

extension MapVC {
    //Mark:- Customzing naviation bar to white
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
}
