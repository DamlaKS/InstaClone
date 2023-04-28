//
//  SettingsVC.swift
//  InstaClone
//
//  Created by Damla KS on 25.04.2023.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle()
    }
    
    func viewTitle () {
        mailLabel.text = "From : \(Auth.auth().currentUser!.email!)"
        mailLabel.textAlignment = .center
    }
    
    @IBAction func LogOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toVC", sender: nil)
        } catch {
            print("error")
        }
    }
    
}
