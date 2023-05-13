//
//  Extension.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 5/2/21.
//

import UIKit


extension MapVC {
    
    enum animateOption {
        case animateIn
        case animateOut
        case BottomToTop(removeFromView: Bool)
        case TopToBottom(removeFromView: Bool)
    }
    
    func animateView(view:UIView, option:animateOption, duration:TimeInterval) {
        
        switch option {
        
        case .animateIn:
            
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            view.alpha = 0
            
            UIView.animate(withDuration: duration) {
                
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                view.alpha = 1
            }
            
        case .animateOut:
            
            UIView.animate(withDuration: 0.2, animations: {
                
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                view.alpha = 0
                
            }, completion: { (success: Bool) in
                
                view.removeFromSuperview()
                
                print("Navigation View Should be removed")
                
            })
            
            

        
        case .BottomToTop(removeFromView: let removeFromView):
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear,
                             animations: {
                                
                                if !removeFromView {
                                    
                                    view.frame.origin.y = -view.frame.height
                                    
                                } else {
                                    
                                    view.frame.origin.y = view.frame.origin.y - view.frame.origin.y
                                    
                                    
                                }

                              
              }, completion: { (success: Bool) in
                
                if removeFromView {
                    
                    view.removeFromSuperview()
                }
                
              })
        case .TopToBottom(removeFromView: let removeFromView):
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear,
                             animations: {
                                 
                                if removeFromView {
                                    
                                    view.frame.origin.y = view.frame.origin.y + view.frame.origin.y
                                    
                                } else {
                                    
                                    view.frame.origin.y = view.frame.height
                                    
                                }
     
                                
                              
              }, completion: { (success: Bool) in
                
                if removeFromView {
                    view.removeFromSuperview()
                }
                
              })
        }
    }

            
    enum position {
        
        case top(parent: UIView, view: UIView, topConstraint:CGFloat, leftConstraint:CGFloat, rightConstraint:CGFloat)
        case bottom(parent: UIView, view: UIView, bottomConstraint:CGFloat, leftConstraint:CGFloat, rightConstraint:CGFloat)
    }
    
    
    func positionPopupView(on posistion:position){
        
        switch posistion {

        case .top(parent: let parent, view: let view, topConstraint: let topConstraint, leftConstraint: let leftConstraint, rightConstraint: let rightConstraint):
            
            parent.addSubview(view)
            
            let leading = view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leftConstraint)
            
            let trailing = view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -rightConstraint)
            
            let top = view.bottomAnchor.constraint(equalTo: parent.topAnchor, constant: topConstraint)
            
            let constraint: [NSLayoutConstraint] = [top, leading, trailing]
            
            NSLayoutConstraint.activate(constraint)
        
        case .bottom(parent: let parent, view: let view, bottomConstraint: let bottomConstraint, leftConstraint: let leftConstraint, rightConstraint: let rightConstraint):
            view.translatesAutoresizingMaskIntoConstraints = false
            
            parent.addSubview(view)
            
            let leading = view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leftConstraint)
            
            let trailing = view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -rightConstraint)
            
            let bottom = view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottomConstraint)
            
            let constraint: [NSLayoutConstraint] = [bottom, leading, trailing]
            
            NSLayoutConstraint.activate(constraint)
        }
        
    }
}


extension UIView{
    
    enum cornerArea {
        
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var cornerIdentifier: CACornerMask {
            
            switch self {
            case .topLeft:
                return .layerMinXMinYCorner
            case .topRight:
                return .layerMaxXMinYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            }
        }
        
    }
    
    
    func roundedEdge(ClipsToBounds:Bool, radius:CGFloat, cornerMask:CACornerMask? = nil ) {
        
        
        self.clipsToBounds = ClipsToBounds

        self.layer.cornerRadius = radius
        
        if let corner = cornerMask {
            
            self.layer.maskedCorners = corner
            
        } else {
            
            self.layer.maskedCorners =
                [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
            
        }
    }
    
    func shadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        
        layer.shadowOffset = offset
        
        layer.shadowColor = color.cgColor
        
        layer.shadowRadius = radius
        
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        
        backgroundColor = nil
        
        layer.backgroundColor =  backgroundCGColor
    }
}
