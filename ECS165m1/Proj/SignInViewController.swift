//
//  SignInViewController.swift
//  Proj
//
//  Created by wwer on 1/26/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignInbuttonTapped(_ sender: Any) {
        print("sign in button tapped")
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        print("SignUpButton tapped")
        
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController, animated: true)
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
