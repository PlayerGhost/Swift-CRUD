//
//  LoginViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 01/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let userEmail = UserDefaults.standard.value(forKey: "USER_EMAIL"){
            let userRequest:NSFetchRequest<User> =  User.fetchRequest()
            userRequest.predicate = NSPredicate(format: "email = %@", userEmail as! String)
            
            do{
                let users = try self.appDelegate.persistentContainer.viewContext.fetch(userRequest)
                
                if let user = users.first {
                    appDelegate.user = user
                    
                    self.performSegue(withIdentifier: "SHOW_CATEGORIES", sender: nil)
                }
            }catch{
                
            }
        }
    }
    
    
    @IBAction func Login(_ sender: Any) {
        let userRequest:NSFetchRequest<User> =  User.fetchRequest()

        userRequest.predicate = NSPredicate(format: "email = %@ and password = %@", self.emailTextField.text!, self.senhaTextField.text!)
        
        do{
            let users = try appDelegate.persistentContainer.viewContext.fetch(userRequest)
            
            if let user = users.first{
                print("Usuario logado com sucesso! Email: \(user.email!)")
                appDelegate.user = user
                
                UserDefaults.standard.set(user.email, forKey: "USER_EMAIL")
                UserDefaults.standard.synchronize()
                
                self.performSegue(withIdentifier: "SHOW_CATEGORIES", sender: sender)
            }else{
                print("Erro ao fazer login!")
            }
        }catch{
            
        }
        
    }
    
    @IBAction func unwind (segue: UIStoryboardSegue){
        
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
