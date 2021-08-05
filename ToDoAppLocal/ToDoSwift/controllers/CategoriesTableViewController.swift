//
//  CategoriesTableViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 08/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = appDelegate.user!.name?.components(separatedBy: " ")[0]
        
        self.loadCategories()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadCategories(){
        self.categories.removeAll()
        
        for category in self.appDelegate.user!.categories!{
            self.categories.append(category as! Category)
        }
        
        self.tableView.reloadData()
    }

    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Nova categoria", message: "Digite o nome da categoria", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let context = self.appDelegate.persistentContainer.viewContext
            
            let categoryName = alert.textFields![0].text!
            
            let newCategory = Category(context: context)
            newCategory.name = categoryName
            newCategory.user = self.appDelegate.user
            
            try? context.save()
            
            self.loadCategories()
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
            let categorytoRemove = self.categories[indexPath.row]
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let context = self.appDelegate.persistentContainer.viewContext
            context.delete(categorytoRemove)
            try? context.save()
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
