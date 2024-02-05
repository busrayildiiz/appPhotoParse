//
//  ViewController.swift
//  appPhotoParse
//
//  Created by MacBook Pro on 1.02.2024.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func signinButton(_ sender: Any) {
        let user = PFUser()
        if usernameTextField.text != "" && passwordTextField.text != "" {
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.errorMessage(title: "Error", message: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else {
            errorMessage(title: "Error", message: "Please, enter username and password.")
        }
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.errorMessage(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else{
            self.errorMessage(title: "Error", message: "Enter username and password")
        }
    }
    
    func errorMessage (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

