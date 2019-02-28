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
    
    var mode : MainProfileViewMode = .ObserveMode
    
    var posts : [String : Any]?
    var following : [String : uint]?
    var follower : [String : uint]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        DatabaseBridge.getProfilePic(userID: Auth.auth().currentUser!.uid) { (data, error) in
            if let imageData = data {
                self.profilePic.image = UIImage(data: data!)
            }
        }
        // Do any additional setup after loading the view.
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
    
    @IBAction func modeButtonClicked(sender : Any) {
        switch mode {
        case .ObserveMode:
            DatabaseBridge.followUser(followingID: self.observingID)
        case .ProfileMode:
            print(123)
        }
    }
    
    func loadProfileData() {
        DatabaseBridge.getFollower { (snapshot) in
            self.follower = snapshot.value as? [String : uint]
            if let _ = self.follower {}
            else {
                self.follower = [String : uint]()
            }
            self.followerCount.text = "\(self.follower!.count)"
        }
        
        DatabaseBridge.getFollowing { (snapshot) in
            self.following = snapshot.value as? [String : uint]
            if let _ = self.follower {}
            else {
                self.following = [String : uint]()
            }
            self.followingCount.text = "\(self.following!.count)"
        }
    }

}
