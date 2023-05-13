//
//  CustomCell.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 2/16/21.
//

import UIKit

class CustomCell: UITableViewCell {
    
     
    @IBOutlet var wellName: UILabel!
    @IBOutlet var wellImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
