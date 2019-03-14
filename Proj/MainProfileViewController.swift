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
    @IBOutlet weak var userDescription: UITextView!
    
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
    }
    
    func changeToProfileView() {
        mode = .ProfileMode
        modeButton.setTitle("Edit Profile", for: .normal)
        modeButton.backgroundColor = .clear
        modeButton.layer.cornerRadius = 5
        modeButton.layer.borderWidth = 0.5
        modeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func loadProfileData() {
        if (self.mode == .ProfileMode) { // profile
            changeToProfileView()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.userData = appDelegate.userData
            
            self.modeButton.addTarget(self, action: #selector(self.showEditableUserProfileView), for: .touchUpInside)
            let collectionViewController = self.children.first as! ProfilePostViewController
            
            let returnButton = collectionViewController.returnButton
            for c in returnButton!.constraints {
                if c.identifier == "ReturnButtonHeight" {
                    c.constant = 0
                }
            }
            returnButton!.setTitle("", for: .normal)
            returnButton?.isUserInteractionEnabled = false
            
        }
        else { // observe
            changeToObserveView(observingID: userData.uid)
            self.modeButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
            
            let collectionViewController = self.children.first as! ProfilePostViewController
            
            let returnButton = collectionViewController.returnButton
            for c in returnButton!.constraints {
                if c.identifier == "ReturnButtonHeight" {
                    c.constant = 30
                }
            }
            returnButton?.addTarget(self, action: #selector(self.dismissWithAnimation), for: .touchUpInside)
            
            dataBaseHandles = UserData.populate(userData: self.userData, userID: self.userData.uid, callback: self.reloadDataAfterFetch)
            
            
        }
        
        reloadDataAfterFetch()
    }

    @objc func showEditableUserProfileView() {
        let profileView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileTableViewController") as! ProfileTableViewController
        
        self.present(profileView, animated: true, completion: nil)
    }
    
    @objc func follow() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.followUser(followingID: self.userData.uid)
        follower?.append(appDel.userData.userName)
        
        modeButton.setTitle("Followed", for: .normal)
        modeButton.removeTarget(nil, action: nil, for: .allEvents)
        modeButton.addTarget(self, action: #selector(self.unfollow), for: .touchUpInside)
    }
    
    @objc func dismissWithAnimation() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func unfollow() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.unfollow(uid: self.userData.uid)
        let index : Int = appDel.userData.following.firstIndex(of: self.userData.uid) ?? -1
        if (index != -1) {
            appDel.userData.following.remove(at: index)
        }
        
        modeButton.setTitle("Follow", for: .normal)
        modeButton.removeTarget(nil, action: nil, for: .allEvents)
        modeButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
    }
    
    func changeViewData() {
        self.postCount.text = "\(self.posts?.count ?? 0)"
        self.followerCount.text = "\(self.follower?.count ?? 0)"
        self.followingCount.text = "\(self.following?.count ?? 0)"
        self.fullUserName.text = "\(self.userData.userName)"
        self.userDescription.text = self.userData.introduction
    }

    func populatePostViewData() {
        let childVC = self.children.first as! ProfilePostViewController
        childVC.posts = self.userData.posts
    }
    
    func reloadDataAfterFetch() {
        self.follower = self.userData.follower
        self.following = self.userData.following
        self.posts = self.userData.posts
        self.profilePic.image = self.userData.profilePic
        changeViewData()
        
        let childVC = self.children.first as! ProfilePostViewController
        childVC.posts = self.userData.posts
        childVC.collectionView.reloadData()
        
        if (mode == .ObserveMode) {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            for userID in userData.follower {
                if (userID == appDel.userData.uid) {
                    modeButton.setTitle("Followed", for: .normal)
                    modeButton.removeTarget(nil, action: nil, for: .allEvents)
                    modeButton.addTarget(self, action: #selector(self.unfollow), for: .touchUpInside)
                    return
                }
            }
            
            modeButton.setTitle("Follow", for: .normal)
            modeButton.removeTarget(nil, action: nil, for: .allEvents)
            modeButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
        }
    }
}
