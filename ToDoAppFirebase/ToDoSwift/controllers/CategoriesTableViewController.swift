//
//  CategoriesTableViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 08/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class CategoriesTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var categories = [FCategory]()
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? "Categories"
            
            self.title = name.components(separatedBy: " ")[0]
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.setuprFirebaseEvnets()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setuprFirebaseEvnets(){
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("categories").child(userID!).observe(.childAdded, with: {(snapshot) -> Void in
            let addedCategory = FCategory(snapshot: snapshot)
            self.categories.append(addedCategory)
            self.tableView.insertRows(at: [IndexPath(row: self.categories.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        })
        
        self.ref.child("categories").child(userID!).observe(.childRemoved, with: {(snapshot) -> Void in
            let removedCategory = FCategory(snapshot: snapshot)
            
            for (index, category) in self.categories.enumerated() {
                if removedCategory.ref!.key! == category.ref!.key!{
                    self.categories.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
    }

    @IBAction func logout(_ sender: Any) {
        try? Auth.auth().signOut()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Nova categoria", message: "Digite o nome da categoria", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let categoryName = alert.textFields![0].text!
            
            let newCategory = FCategory()
            newCategory.name = categoryName
            
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("categories").child(userID!).childByAutoId().setValue(newCategory.toDtictionary())
        }
        
        let cancelAction = UIAlertAction(title: "Fechar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CATEGORY_CELL", for: indexPath)

        let category = self.categories[indexPath.row]
        
        cell.textLabel?.text = category.name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = self.categories[indexPath.row]
            let userID = Auth.auth().currentUser?.uid
            
            var multiplePaths = [String: Any]()
            multiplePaths["categories/\(userID!)/\(category.ref!.key!)"] = [:]
            multiplePaths["tasks/\(category.ref!.key!)"] = [:]
            
            self.ref.updateChildValues(multiplePaths)
            
            //category.ref!.removeValue()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SHOW_TASKS"{
            let dvc = segue.destination as! TasksTableViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                dvc.category = self.categories[indexPath.row]
            }
        }
    }
}
