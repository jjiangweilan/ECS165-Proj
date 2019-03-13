//
//  !@#ViewController.swift
//  Proj
//
//  Created by Zexu Li on 2/26/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Firebase
class MainProfileViewController: UIViewController {
    enum MainProfileViewMode {
        case ObserveMode, ProfileMode
    }
    
    var observingID : String! = nil
    
    @IBOutlet weak var modeButton : UIButton!
    @IBOutlet weak var followerCount : UILabel!
    @IBOutlet weak var followingCount : UILabel!
    @IBOutlet weak var postCount : UILabel!
    @IBOutlet weak var profilePic : UIImageView!
    @IBOutlet weak var fullUserName : UILabel!
    
    var mode : MainProfileViewMode = .ProfileMode
    
    var posts : [Post]?
    var following : [String]?
    var follower : [String]?
    
    var userData : UserData! = nil
    var dataBaseHandles : [UInt]! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadProfileData()
        changeViewData()
        populatePostViewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let handles = self.dataBaseHandles {
            for h in handles {
                DatabaseBridge.stopObserving(handle: h)
            }
        }
    }
    
    func changeToObserveView(observingID : String) {
        mode = .ObserveMode
        
        self.observingID = observingID
        
        DatabaseBridge.databaseHas(path: "following/\(Auth.auth().currentUser!.uid)/\(observingID)", hasCallback: {
            self.modeButton.titleLabel?.text = "Followed"
            self.modeButton.isUserInteractionEnabled = false
            
        }, hasNotCallback: {
            self.modeButton.titleLabel?.text = "Follow"
            self.modeButton.isUserInteractionEnabled = true
        })
    }
    
    func changeToProfileView() {
        mode = .ProfileMode
        modeButton.titleLabel?.text = "Edit Profile"
    }
    
    func loadProfileData() {
        if (self.mode == .ProfileMode) { // profile
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.userData = appDelegate.userData
            
            self.modeButton.addTarget(self, action: #selector(self.showEditableUserProfileView), for: .touchUpInside)
            changeToProfileView()
        }
        else { // observe
            changeToObserveView(observingID: userData.uid)
            self.modeButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
        }
        
        self.follower = self.userData.follower
        self.following = self.userData.following
        self.posts = self.userData.posts
        self.profilePic.image = self.userData.profilePic
    }

    @objc func showEditableUserProfileView() {
        let profileView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileTableViewController") as! ProfileTableViewController
        
        self.present(profileView, animated: true, completion: nil)
    }
    
    @objc func follow() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.followUser(followingID: self.userData.uid)
        follower?.append(appDel.userData.userName)
        
    }
    
    @objc func unfollow() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.unfollow(uid: self.userData.uid)
        let index : Int = appDel.userData.following.firstIndex(of: self.userData.uid) ?? -1
        if (index != -1) {
            appDel.userData.following.remove(at: index)
        }
    }
    
    func changeViewData() {
        self.postCount.text = "\(self.posts?.count ?? 0)"
        self.followerCount.text = "\(self.follower?.count ?? 0)"
        self.followingCount.text = "\(self.following?.count ?? 0)"
        self.fullUserName.text = "\(self.userData.userName)"
    }

    func populatePostViewData() {
        let childVC = self.children.first as! ProfilePostViewController
        childVC.posts = self.userData.posts
    }
}
