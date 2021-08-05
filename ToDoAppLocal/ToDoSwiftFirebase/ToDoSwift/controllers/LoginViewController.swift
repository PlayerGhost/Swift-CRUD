//
//  LoginViewController.swift
//  ToDoSwift
//
//  Created by Player Ghost on 01/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let _ = user {
                self.performSegue(withIdentifier: "SHOW_CATEGORIES", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func Login(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.senhaTextField.text!) {
            authResult, error in
            
            if let error = error{
                let alert = UIAlertController(title: "Erro ao fazer login!", message: "Erro: \(error.localizedDescription)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default){(action) in
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "SHOW_CATEGORIES", sender: sender)
            }
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
