//
//  ProfileViewController.swift
//  Proj
//
//  Created by jiehong jiang on 2/12/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        /* force to end editing first. If not, the editing will be ended
         * after logout which causes error */
        self.view.endEditing(true);
        do {
            try
            Auth.auth().signOut()
            FBSDKLoginManager.init().logOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch {
            //signout failed
        }
        //jump to the first page
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
