//
//  MyStocksTableViewController.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import Foundation
import UIKit
import CoreData

class MyStocksTableViewController : UITableViewController{
    
    
    @IBOutlet var tableView1: UITableView!
    
    @IBOutlet weak var edit: UIBarButtonItem!
    
    
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var myFetchResultController : NSFetchedResultsController<Stocks> = {
        
        let fetch : NSFetchRequest<Stocks> = Stocks.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: delegate.persistentContainer.viewContext, sectionNameKeyPath: "isActive", cacheName: nil)
        
         ftc.delegate = self
         
        return ftc
        
    }()
    
    lazy var xNotes : [Notes]? = [Notes]()  {
        didSet {// there is a better
            tableView1.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Stocks"
        navigationController?.isToolbarHidden = false
        try? myFetchResultController.performFetch()
        
        
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
       
        if tableView1.isEditing{
            tableView1.isEditing = false
            edit.title = "edit"
        }else{
            tableView1.isEditing = true
            edit.title = "done"
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return myFetchResultController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myFetchResultController.sections?[section].numberOfObjects ?? 0

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : StockTableCell = tableView1.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockTableCell
        let item = myFetchResultController.object(at: indexPath)
        cell.configCell(result: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0: return "Active"
        case 1 : return "Watch List"
        default : return ""
        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var itemFrom = myFetchResultController.object(at: sourceIndexPath)
        var itemTo = myFetchResultController.object(at: destinationIndexPath)
        var moveObj = itemFrom
        itemFrom = itemTo
        itemTo = moveObj
       
        try? delegate.persistentContainer.viewContext.save()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedRow = indexPath
        let alertController = UIAlertController(title: "Notes", message: "Add notes", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField()
       
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {_ in
            let userNotes = alertController.textFields?[0]
            
            let stockNotes = self.myFetchResultController.object(at: selectedRow)
        
            let newNotes = Notes(context: self.delegate.persistentContainer.viewContext)
          
            newNotes.notes = userNotes?.text
            
            stockNotes.addToNotes(newNotes)
            self.xNotes?.append(newNotes)

            self.delegate.saveContext()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}

extension MyStocksTableViewController : NSFetchedResultsControllerDelegate {
    // These methods are called by the iOS runtime, in response to user interaction and/or changes in the data source
    
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update(s)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    }
}
extension MyStocksTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate? = nil
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[c] %@ ", searchText)
        }
        //NSFetchedResultsController
        myFetchResultController.fetchRequest.predicate = predicate
        try? myFetchResultController.performFetch()
        tableView.reloadData()
        
    }
}

