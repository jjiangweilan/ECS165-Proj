//
//  SignInViewController.swift
//  Proj
//
//  Created by wwer on 1/26/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignInbuttonTapped(_ sender: Any) {
        var emailStr : String? = EmailTextField.text
        var passwordStr : String? = PasswordTextField.text
        
        // validate required fields are not empty
        if  (EmailTextField.text?.isEmpty)! ||
            (PasswordTextField.text?.isEmpty)!
        {
            //Display alert messege and return
            displayAlert(userMessage: "All fields are required to fill in")
            return
        }
        
        
        
        //emailStr, passwordStr should be validated before passing to this function
        //...
        DatabaseBridge.signIn(withEmail: emailStr!, password: passwordStr!) {
            (user, error) in
            
            if let e = error {
                switch e {
                case AuthErrorCode.wrongPassword:
                    print("wrong password")
                default:
                    print(e)
                }
            }
            
            if let u = user {
                if !u.user.isEmailVerified {
                    do {
                        try Auth.auth().signOut()
                        self.displayAlert(userMessage: "Email is not vertified")
                    }
                    catch {
                    
                    }
                }
                else {
                    self.showUserInfoView()
                }
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        print("SignUpButton tapped")
        
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController, animated: true)
    }
    
    
    func showUserInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func displayAlert(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action:UIAlertAction!) in
                    print("Ok button tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController,animated: true, completion: nil)
                
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
