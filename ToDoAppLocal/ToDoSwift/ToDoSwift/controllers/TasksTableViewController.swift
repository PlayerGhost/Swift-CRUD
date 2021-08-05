//
//  TasksTableViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 10/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var category: Category?
    
    var tasks = [Task]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.category{
            self.title = category.name
            
            self.loadTasks()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadTasks(){
        self.tasks.removeAll()
        
        for task in category!.task!{
            self.tasks.append(task as! Task)
        }
        
        self.tableView.reloadData()
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
        
        if task.done {
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
            let taskToRemove = self.tasks[indexPath.row]
            self.tasks.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.appDelegate.persistentContainer.viewContext.delete(taskToRemove)
            try? self.appDelegate.persistentContainer.viewContext.save()
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
        try? self.appDelegate.persistentContainer.viewContext.save()
        
        self.loadTasks()
    }

    @IBAction func unwindNewTask(segue: UIStoryboardSegue){
        let svc = segue.source as! TaskViewController
        let newTask = svc.task
        newTask?.category = self.category
        
        try? self.appDelegate.persistentContainer.viewContext.save()
        
        self.loadTasks()
    }
}
