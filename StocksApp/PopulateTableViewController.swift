//
//  PopulateTableViewController.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import Foundation
import UIKit

protocol didfinishSearchDelegate : AnyObject {
    func didFinishSearchWith(result : Results?)
}

class PopulateTableViewController : UITableViewController{
   
    weak var delegate : didfinishSearchDelegate?
    var res : [Results]? = nil {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return res?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = self.res?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didFinishSearchWith(result: res?[indexPath.row])
        
    }

    
}




