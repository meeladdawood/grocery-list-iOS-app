//
//  ViewController.swift
//  GroceryList
//
//  Created by Meelad Dawood on 2/27/18.
//  Copyright © 2018 Meelad Dawood. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    var stores : [NSManagedObject] = []
    
    
    @IBOutlet var tableViewMainScreen: UITableView!
    
    
    @IBAction func AddStore(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Store",
                                      message: "Add a new store",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let storeToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(storeName: storeToSave)
                                        self.tableViewMainScreen.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    
    
    func save(storeName: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Stores",
                                       in: managedContext)!
        
        let store = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        store.setValue(storeName, forKeyPath: "storeName")
        
        // 4
        do {
            try managedContext.save()
            stores.append(store)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            
            let store = stores[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text = store.value(forKeyPath: "storeName") as? String
            return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stores"
        tableViewMainScreen.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Stores")
        
        //3
        do {
            stores = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
}

