//
//  ViewController.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import UIKit

class ViewController: UIViewController {
    
    var performanceId = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete?q=gm"
        
        
        Service.shared.getData(url: url){ result in
            switch(result){
            case .failure(let err): print("error getting api result \(err)")
            case .success(let data): print("data \(data)")
                if let stocks = try? JSONDecoder().decode(ResultSet.self, from: data) {
                    DispatchQueue.main.async {
                        if stocks.count > 0{
                            self.performanceId = stocks.results[0].performanceId
                            self.name = stocks.results[0].name
                            print("name \(self.name) performanceId \(self.performanceId)")
                            
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
 
    
    
    
}
