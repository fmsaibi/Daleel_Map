import UIKit
import NMAKit


class Marker: NSObject {
    
    static let shared = Marker()
    
    /**
     * @note Adding Pin(Marker) to the Map View
     */
    
    //Mark:- Adding Well circle on the map
    static func addImage(_ mapView: NMAMapView,_ container: NMAMapContainer, _ label: String,_ lat:Double, _ Long:Double, displayImage:UIImage, _ isDraggable: Bool) {

        let imageIcon = NMAImage(uiImage: displayImage)//Add Image to a Marker
        
        let marker = NMAMapLabeledMarker(geoCoordinates: NMAGeoCoordinates(latitude: lat, longitude: Long), icon: imageIcon!)//Add Image and coorinates
        
        marker.isDraggable = isDraggable //Enable Marker to be draggabl
        
        marker.accessibilityContainerType = .list //Setting up Marker Type
        
        marker.accessibilityLabel = label // Give Marker a Label Name
        

        container.add(marker)//Adding marker to the continer
   
        
        mapView.add(mapObject: container)//Adding Marker continer to the map object

    }
    
    
    static func hideFromMapView(from mapContainer:NMAMapContainer, with lable: String){
        let objects = mapContainer.mapObjects as! [NMAMapMarker]
        
        for eachObject in objects {
            
            if eachObject.accessibilityLabel == lable {
                
                eachObject.isVisible = false
                
            }
        }
    }
    
    static func showOnMapView(from mapContainer:NMAMapContainer, with lable: String){
        let objects = mapContainer.mapObjects as! [NMAMapMarker]
        
        for eachObject in objects {
            
            if eachObject.accessibilityLabel == lable {
                
                eachObject.isVisible = true
                
            }
        }
    }
}

extension MapVC {
    
    func textImage(text: String) -> UIImage {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 90, height: 74))

        let img = renderer.image { ctx in
            
            //Mark:- Setting the Image aliment to Center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            //Mark:- Customazing the Image Fonts and alignment
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                        .paragraphStyle: paragraphStyle]
            
            //Mark:- Draw Text to image
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            let textWidth = attributedString.size().width
            attributedString.draw(at: CGPoint(x: (90 - textWidth)/2, y: 0))
            
            // Placing Image
            let img = UIImage(named: "well_small")
            /*
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            img.image = UIImage(named: "well_small")
            */
            
            //icons8-select-24

            if let imgWidth = img?.size.width {
                let x = (90/2) - (imgWidth/2)
                img?.draw(at: CGPoint(x: x, y: attributedString.size().height))
            }

        }
        
        return img
    }
}
