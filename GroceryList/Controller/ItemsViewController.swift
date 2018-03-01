//
//  ItemsViewController.swift
//  GroceryList
//
//  Created by Meelad Dawood on 2/28/18.
//  Copyright © 2018 Meelad Dawood. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UITableViewController {
    
    @IBOutlet var TotalPriceLabel: UILabel!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedStore : Stores? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TotalPriceLabel.text = "Total Price $0.00"
        loadTotal()
    
        
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
             cell.detailTextLabel?.text = String(item.price)
            
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //Remove Function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if let item = todoItems?[indexPath.row] {
                try! realm.write {
                    realm.delete(item)
                }
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
        loadTotal()
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        loadTotal()
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        var textFieldPrice = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentStore = self.selectedStore {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.price = Double(textFieldPrice.text!)!
                        newItem.dateCreated = Date()
                        currentStore.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            self.loadTotal()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Price"
            alertTextField.keyboardType = UIKeyboardType.decimalPad
            textFieldPrice = alertTextField
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

        
        loadTotal()
    }
    
    
    //MARK - Model Manupulation Methods
    func loadItems() {
        
        todoItems = selectedStore?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        loadTotal()
        
    }
    
    
    func loadTotal() {
        var sum: Double = 0.0
        for item in (selectedStore?.items)! {
            sum += item.price
        }

        TotalPriceLabel.text = "Total Price $ \(sum)"
           
    }
    
}


