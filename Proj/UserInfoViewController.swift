//
//  userInfoViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 1/27/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
// 

import UIKit
import Firebase

class UserInfoViewController: UIViewController {

    
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var changePhoto: UIButton!
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    
    @IBAction func logout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch {
            //signout failed
        }
        //jump to the first page
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseBridge.getUserInfo(snapshotFunc: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.name.text =  value?["username"] as? String ?? ""
            self.email.text =  value?["email"] as? String ?? ""
            self.gender.text =  value?["gender"] as? String ?? ""
            self.phone.text =  value?["phone"] as? String ?? ""
        })
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
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
