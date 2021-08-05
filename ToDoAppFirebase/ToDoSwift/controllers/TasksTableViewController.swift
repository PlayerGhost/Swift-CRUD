//
//  TasksTableViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 10/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class TasksTableViewController: UITableViewController {
    
    var category: FCategory?
    
    var tasks = [FTask]()
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.category{
            self.title = category.name
            
            self.setuprFirebaseEvnets()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setuprFirebaseEvnets(){
        
        self.ref.child("tasks").child(self.category!.ref!.key!).observe(.childAdded, with: {(snapshot) -> Void in
            let addedTask = FTask(snapshot: snapshot)
            self.tasks.append(addedTask)
            self.tableView.insertRows(at: [IndexPath(row: self.tasks.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        })
        
        self.ref.child("tasks").child(self.category!.ref!.key!).observe(.childRemoved, with: {(snapshot) -> Void in
            let removedTask = FTask(snapshot: snapshot)
            
            for (index, task) in self.tasks.enumerated() {
                if removedTask.ref!.key! == task.ref!.key!{
                    self.tasks.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
        
        self.ref.child("tasks").child(self.category!.ref!.key!).observe(.childChanged, with: {(snapshot) -> Void in
            let updatedTask = FTask(snapshot: snapshot)
            
            for (index, task) in self.tasks.enumerated() {
                if updatedTask.ref!.key! == task.ref!.key!{
                    self.tasks[index] = updatedTask
                    self.tableView.reloadData()
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TASK_CELL", for: indexPath)

        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        if task.done! {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }

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
            let task = self.tasks[indexPath.row]
            task.ref!.removeValue()
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
        
        if let indexPath = self.tableView.indexPathForSelectedRow{
            if(segue.identifier == "EDIT_TASK"){
                let dvc = segue.destination as! TaskViewController
                dvc.task = self.tasks[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindEditText(segue: UIStoryboardSegue){
        let svc = segue.source as! TaskViewController
        let updatedTask = svc.task
        
        updatedTask?.ref!.updateChildValues(updatedTask!.toDtictionary())
    }

    @IBAction func unwindNewTask(segue: UIStoryboardSegue){
        let svc = segue.source as! TaskViewController
        let newTask = svc.task
        
        
        self.ref.child("tasks").child(self.category!.ref!.key!).childByAutoId().setValue(newTask?.toDtictionary())
    }
}
