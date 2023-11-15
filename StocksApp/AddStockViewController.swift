//
//  AddStockViewController.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import Foundation
import UIKit
import CoreData

class AddStockViewController : UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var isActiveState: UISegmentedControl!
    var performanceId = ""
    var name = ""
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var newItems = [NSManagedObject?]()
    var isActive = false
    
    var thisStock :Stocks? = nil{
        didSet{
            
        }
    }
//    lazy var notes : [Notes]? = [Notes]() {
//        didSet{
//
//        }
//    }
//
    lazy var populateTableController = self.storyboard?.instantiateViewController(withIdentifier: "populateTv") as? PopulateTableViewController
    lazy var searchController = UISearchController(searchResultsController: populateTableController)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        isActiveState.isHidden = true
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        populateTableController?.delegate = self
        
        let fetchRequest = Stocks.fetchRequest()//give all the students
       //  fetchRequest.predicate = NSPredicate(format: "name == %@", "john")
         if let results = try? delegate.persistentContainer.viewContext.fetch(fetchRequest){
             for item in results{
                 print("item \(item.isActive) \(String(describing: item.name)) \(String(describing: item.performanceId)) ")
             }
         }
            
        
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        print("add clicked")
        
        if isActiveState.selectedSegmentIndex == 0 {
            isActive = true
        }
        thisStock?.isActive = isActive
        delegate.saveContext()
         dismiss(animated: true)
    }
    
    
    func callingApi(){
        let searchText = searchController.searchBar.text ?? ""

        let url = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete?q=\(searchText)"
        
        
        Service.shared.getData(url: url){ result in
            switch(result){
            case .failure(let err): print("error getting api result \(err)")
            case .success(let data): print("data \(data)")
                if let stocks = try? JSONDecoder().decode(ResultSet.self, from: data) {
                    self.populateTableController?.res = stocks.results
                }
                
            }
        }

    }
    
}

extension AddStockViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
            callingApi()
    }
    
}

extension AddStockViewController : didfinishSearchDelegate{
    func didFinishSearchWith(result: Results?) {
        title = result?.name
        searchController.isActive = false
        isActiveState.isHidden = false

        if thisStock == nil{
            thisStock = Stocks(context: delegate.persistentContainer.viewContext)
        }
        
        newItems.append(thisStock)
        thisStock?.name = result?.name
        thisStock?.performanceId = result?.performanceId
        
    }
    
}



