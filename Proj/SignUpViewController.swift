//
//  SingUpViewController.swift
//  Proj
//
//  Created by wwer on 1/26/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RepeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func CancleButtonTapped(_ sender: Any) {
        print("cancleButton tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        print("sign up button tapped")
        
        // validate required fields are not empty
        if (UserNameTextField.text?.isEmpty)! ||
            (EmailTextField.text?.isEmpty)! ||
            (PasswordTextField.text?.isEmpty)!
            {
                //Display alert messege and return
                displayAlert(userMessage: "All fields are required to fill in")
                return
            }
        
        // validate password
        if ((PasswordTextField.text?.elementsEqual(RepeatPasswordTextField.text!))! != true)
        {
            // Display alert messege and return
            displayAlert(userMessage: "Please make sure that passwords match")
            return
        }
        //creat activity indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        // position activity indicator in the cneter view
        myActivityIndicator.center = view.center
        
        // prevent activity indicator from hiding when stopAnimation is called
        myActivityIndicator.hidesWhenStopped = false
        
        // start activity indicator
        myActivityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        view.addSubview((myActivityIndicator))
        
        
        //after all validation:
        var emailStr : String! = EmailTextField.text
        var passwordStr : String! = PasswordTextField.text
        let userName :String! = UserNameTextField.text
        DatabaseBridge.createUser(withEmail: emailStr!, password: passwordStr!) {
            (user, error) in
            self.view.isUserInteractionEnabled = true
            myActivityIndicator.removeFromSuperview()
            
            if let e = error {
                switch e {
                case AuthErrorCode.emailAlreadyInUse:
                    print("email in use")
                case AuthErrorCode.invalidEmail:
                    print("email is invalid")
                case AuthErrorCode.missingEmail:
                    print("missing email")
                default:
                    break
                }
            }
            else {
                user?.user.sendEmailVerification(completion: (nil))
                DatabaseBridge.createUserData(user: user!, name: userName, email: emailStr)
            }
        }
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


