//
//  CategoriesViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 03/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var categories 
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = appDelegate.user?.name?.components(separatedBy: " ")[0]
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
    }
    
    @IBAction func newCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Nova categoria", message: "Digite o nome da categoria", preferredStyle: .alert)
        
        //alert.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
        
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
