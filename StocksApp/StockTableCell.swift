//
//  StockTableCell.swift
//  StocksApp
//
//  Created by user243757 on 10/17/23.
//

import Foundation
import UIKit


class StockTableCell : UITableViewCell{
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var notesLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setNotesLabel(notesList:NSSet?)-> String{
        var notesString = "Notes:"
        if let notesArr = notesList {

                //if notes exists, joining all notes wiht a "," and storing it in a string
                if notesArr.count>0{
                    var notesDescArr = [String]()
                    for eachNote in notesArr.reversed(){
                        if let noteDesc = (eachNote as! Notes).notes{
                            notesDescArr.append(noteDesc)
                        }
                    }
                    let oldNotesString = notesDescArr.joined(separator:"\n")
                    //appending Notes: with already added notes string
                    notesString = notesString+oldNotesString
                }
                print("notesString \(notesString)")
//                stockNotesLabel.text = notesString
            }else{
                print("empty notes")
//                stockNameLabel.text = ""
            }
        return notesString
        }
    func configCell(result: Stocks){
        textLabel?.text = result.name
    
        
        var detailNotes =  setNotesLabel(notesList: result.notes)

        if let performanceId = result.performanceId{
            let url =        "https://ms-finance.p.rapidapi.com/market/v2/get-realtime-data?performanceIds=\(performanceId)"
            
                    Service.shared.getData(url: url){ result in
                        switch(result){
                        case .failure(let err): print("error getting api result \(err)")
                        case .success(let data): print("data success \(data)")
                     
                            guard let res = try? JSONDecoder().decode(StockData.self, from: data) else{
                                print("parsing failed")
                                DispatchQueue.main.async {
                                    self.detailTextLabel?.text = ""
                               
                                }
                                return }
                        
                            if let stocks = res[performanceId]{
                                print("stocks \(stocks)")
                                    DispatchQueue.main.async {[unowned self] in
                                        let stringVal = String(stocks.lastPrice.value)
                                        print( " price  \(stringVal)")
                                        self.detailTextLabel?.text = "\(stringVal) \n \(detailNotes)"
                                    }

                                }
                        }
                    }

        }

        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
