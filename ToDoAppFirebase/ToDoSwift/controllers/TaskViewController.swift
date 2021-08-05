//
//  TaskViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 17/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var doneSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var task: FTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = self.task{
            self.nameTextField.text = task.name
            self.prioritySegmentControl.selectedSegmentIndex = task.priority!
            self.doneSwitch.isOn = task.done!
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ok(_ sender: Any) {
        if let task = self.task{
            task.name = self.nameTextField.text
            task.priority = prioritySegmentControl.selectedSegmentIndex
            task.done = doneSwitch.isOn
            
            self.performSegue(withIdentifier: "EDIT_TASK", sender: sender)
        }else{
            let newTask = FTask()
            newTask.name = self.nameTextField.text
            newTask.priority = self.prioritySegmentControl.selectedSegmentIndex
            newTask.done = self.doneSwitch.isOn
            
            self.task = newTask
            
            self.performSegue(withIdentifier: "NEW_TASK", sender: sender)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
