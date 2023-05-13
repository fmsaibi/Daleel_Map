//
//  SearchVC.swift
//  Daleel Map
//
//  Created by Fahad Al Khusaibi on 3/31/21.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var delegate: SearchResultDelegate!
    var filterData = [MapData]()
    var isFiltered = false
    
    override func viewWillAppear(_ animated: Bool) {
        overrideUserInterfaceStyle = .light
    }
    
}


extension SearchVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltered {
            
            if !filterData.isEmpty {
                
                return filterData.count
                
            } else {
                
                return 1
            }
            
        } else {
            
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        if isFiltered {

            if !filterData.isEmpty {

                cell.wellName.text = filterData[indexPath.row].well
                cell.wellName.textColor = .black
                cell.wellImage.image = UIImage(named: "well_big")

            } else {
                cell.wellName.text = "No Data Found"
                cell.wellName.textColor = .red
                cell.wellImage.image = nil

            }

        }
            
        return cell
    }
    
    
}

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        
        if !filterData.isEmpty {
            
            let selectedCell = filterData[indexPath.row]
            
            delegate.searchViewDidSelectResult(selectedCell)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
        
            self.dismiss(animated: true, completion: nil)
        }
    }
}



