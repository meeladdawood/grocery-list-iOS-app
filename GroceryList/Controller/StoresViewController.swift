//
//  ViewController.swift
//  GroceryList
//
//  Created by Meelad Dawood on 2/27/18.
//  Copyright © 2018 Meelad Dawood. All rights reserved.
//

import UIKit
import RealmSwift

class StoresViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var stores: Results<Stores>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = stores?[indexPath.row].name ?? "No Store Added Yet"
        
        return cell
        
    }
    
    //Remove Function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if let item = stores?[indexPath.row] {
                try! realm.write {
                    realm.delete(item)
                }
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStore = stores?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(store: Stores) {
        do {
            try realm.write {
                realm.add(store)
            }
        } catch {
            print("Error saving store \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        stores  = realm.objects(Stores.self)
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Store", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newStore = Stores()
            newStore.name = textField.text!
            
            self.save(store: newStore)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new store"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}
