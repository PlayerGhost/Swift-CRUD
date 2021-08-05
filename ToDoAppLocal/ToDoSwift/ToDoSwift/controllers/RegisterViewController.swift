//
//  RegisterViewController.swift
//  ToDoSwift
///Users/playerghost/Desktop/ToDoSwift/ToDoSwift/controllers/RegisterViewController.swift
//  Created by Player Ghost on 01/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var confirmarSenhaTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func okClicked(_ sender: Any) {
        if self.senhaTextField.text! == self.confirmarSenhaTextField.text!{
            let newUser = User(context: appDelegate.persistentContainer.viewContext)
            
            newUser.name = self.nameTextView.text
            newUser.email = self.emailTextField.text
            newUser.password = self.senhaTextField.text
            
            let context = appDelegate.persistentContainer.viewContext
            
            if context.hasChanges{
                do{
                    try context.save()
                    
                    print("sergsed")
                    
                    let alert = UIAlertController(title: "Sucesso!", message: "Conta criada com sucesso", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default){(action) in
                        self.performSegue(withIdentifier: "UNWIND_REGISTER", sender: nil)
                        

                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }catch{
                    
                    appDelegate.persistentContainer.viewContext.delete(newUser)
                    
                }
            }
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
