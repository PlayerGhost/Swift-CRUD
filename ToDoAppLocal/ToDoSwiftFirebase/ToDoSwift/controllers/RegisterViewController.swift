//
//  RegisterViewController.swift
//  ToDoSwift
///Users/playerghost/Desktop/ToDoSwift/ToDoSwift/controllers/RegisterViewController.swift
//  Created by Player Ghost on 01/06/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var confirmarSenhaTextField: UITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func okClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Criando usuário", message: "Aguarde um momento...", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        if self.senhaTextField.text! == self.confirmarSenhaTextField.text!{
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.senhaTextField.text!) { authResult, error in
                alert.dismiss(animated: true, completion: nil)
                
                if let error = error{
                    print("Erro: \(error.localizedDescription)")
                } else{
                    let user = Auth.auth().currentUser!
                    
                    self.ref.child("users").child(user.uid).setValue(["name": self.nameTextView.text!])
                    
                    let alert = UIAlertController(title: "Sucesso!", message: "Conta criada com sucesso", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default){(action) in
                        self.performSegue(withIdentifier: "UNWIND_REGISTER", sender: nil)
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
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
