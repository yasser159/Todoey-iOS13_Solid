//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    //Array contains items that will show up on the screen
    var itemArray = [Item]()
    
    let dataFilePath =  FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
/*
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
      
        let newItem2 = Item()
        newItem2.title = "Find Jessica"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Steven"
        itemArray.append(newItem3)
   */
        // Do any additional setup after loading the view.
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
    
    }

    //MARK - Tableview Datasource Methods
    
    //Function returns number of rows in array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Function ???
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item .title
        
        //Ternary operator ==>
        // value = conditions ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods  _ will run when row is selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //print("textField: ", textField.text)
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //print("textField: ", textField.text)
//            self.itemArray.append(textField.text!)
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
//            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Encode Data
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }

    //load items
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error encoding item array, \(error)")
            }
            
        }
    }
    
}

