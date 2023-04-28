//
//  ViewController.swift
//  InstaClone
//
//  Created by Damla KS on 24.04.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { [self] authdata, error in
                if error != nil {
                    makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Failed", messageInput: "email and password cannot be empty")
        }
        
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { [self] authdata, error in
                if error != nil {
                    makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //makeAlert(titleInput: "Singed UP", messageInput: "Your account created")
                    performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Failed", messageInput: "email and password cannot be empty")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

