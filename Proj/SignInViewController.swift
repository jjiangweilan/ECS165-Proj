//
//  SignInViewController.swift
//  Proj
//
//  Created by wwer on 1/26/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseDatabase

class SignInViewController: UIViewController,FBSDKLoginButtonDelegate {
   
    

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate = self
        
        facebookLoginButton.readPermissions = ["email"]
        self.view.viewWithTag(1)!.layer.cornerRadius = 5
        
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
                self.displayAlert(userMessage: e.localizedDescription)
            }
            
            else if let u = user {
                if !u.user.isEmailVerified {
                    do {
                        try Auth.auth().signOut()
                        self.displayAlert(userMessage: "Email is not vertified")
                    }
                    catch {
                    
                    }
                }
                else {
                    self.showMainView(authData: user!)
                }
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        print("SignUpButton tapped")
        
        //this is done in storyboard
//        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        self.present(signUpViewController, animated: true)
    }
    
    
    func showMainView(authData : AuthDataResult) {
        let user = authData.user
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        appDel.userData.uid = user.uid
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.present(controller, animated: true, completion: nil)
        
        for c in controller.children {
            if let castedController = c as? MainProfileViewController {
                let _ = castedController.view
                castedController.userData = UserData()
                castedController.mode = .ProfileMode
                
                for cc in controller.children {
                    if let postTableViewController = cc as? PostTableViewController {
                        appDel.callback = {
                            castedController.reloadDataAfterFetch()
                            postTableViewController.reloadDataAfterFetch()
                        }
                    }
                }
                
                let handles = UserData.populate(userData: appDel.userData, userID: user.uid, callback: appDel.callback!)
                appDel.handles.append(contentsOf: handles)
                appDel.handles.append(DatabaseBridge.observeFollower(uid: user.uid))
                break
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
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        if let error = error {
            print("Error took place \(error.localizedDescription)")
                return
        }
        
        if result.isCancelled {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // TO_DO: signIn failed
                return
            }
            DatabaseBridge.databaseHas(path: "users/\(authResult!.user.uid)", hasCallback: nil, hasNotCallback: {
                DatabaseBridge.createUserData(user: authResult!, name: authResult?.user.displayName ?? "", email: authResult?.user.email ?? "")
            })
            self.showMainView(authData: authResult!)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
            
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
