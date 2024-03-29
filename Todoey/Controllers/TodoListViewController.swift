//
//  ViewController.swift
//  Todoey
//
//  Created by Rwan on 2019/11/21.
//  Copyright © 2019 Rwan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var Array = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
//
//        let newItem1 = Item()
//        newItem1.title = "First"
//        Array.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Second"
//        Array.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Third"
//        Array.append(newItem3)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            Array = items
//
//        }
        loadItems()
        
    }
    
    
  // return cell numbers numberOfRowInSection ------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    
    
  // Return cell cellForRowAtIndexPath -------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndex Called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = Array[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none // 三元运算符
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }

  // MARK didSelectRowAtIndexPath -------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        Array[indexPath.row].done = !Array[indexPath.row].done // 一行代码实现下面if条件语句的效果
//        if Array[indexPath.row].done == false {
//            Array[indexPath.row].done = true
//        } else {
//            Array[indexPath.row].done = false
//        }
        
        saveItems()
        
        // Reload the Data ----------------------------
        //tableView.reloadData()     //saveItems() method also has this reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  // IBAction Pressed  + Button -------------------------------------
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the "Add Item" button on our UIAlert
        
            let newItem = Item()
            newItem.title = textField.text!
            self.Array.append(newItem)
            
           // self.defaults.set(self.Array, forKey: "ToDoListArray")
           
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
            //print(alertTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(Array)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                Array = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding array \(error)")
            }
        }
    }
}


