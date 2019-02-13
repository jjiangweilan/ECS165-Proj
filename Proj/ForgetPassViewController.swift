//
//  ForgetPassViewController.swift
//  Proj
//
//  Created by wwer on 2/11/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
class ForgetPassViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        if (emailTextField.text?.isEmpty)!
        {
            displayAlert(userMessage: "All fields are required to fill in")
            return
        }
        else {
            let email = emailTextField.text!
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let e = error {
                    self.displayAlert(userMessage: e.localizedDescription)
                }
                self.displayAlert(userMessage: "Reset email has been sent")
            }
        }
        
    }
    
    func displayAlert(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action:UIAlertAction!) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController,animated: true, completion: nil)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
