//
//  ShowPostViewController.swift
//  Proj
//
//  Created by wwer on 3/13/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class ShowPostViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var postPic: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numberLikes: UILabel!
    
    var userID : String! = ""
    var postID : String! = ""
    
    // get username, post pic, post content, profile pic
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    
        let fixedWidth = postContent.frame.size.width
        let newSize = postContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        postContent.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        // Do any additional setup after loading the view.
    }
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.singleObservation(path: "posts/\(userID)/\(postID)/likes/\(appDel.userData.uid)") { (dataSnapshot) in
            if let _ = dataSnapshot.value as? uint {
                self.likeButton.removeTarget(nil, action: nil, for: .allEvents)
                self.likeButton.addTarget(self, action: #selector(self.dislikeButton(_:)), for: .touchUpInside)
                self.likeButton.setImage(UIImage(named: "liked"), for: .normal)
            }
            else {
                self.likeButton.removeTarget(nil, action: nil, for: .allEvents)
                self.likeButton.addTarget(self, action: #selector(self.likeClicked(_:)), for: .touchUpInside)
                self.likeButton.setImage(UIImage(named: "like"), for: .normal)
            }
        }
    }
    
    @objc func likeClicked(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.updateData(path: "posts/\(userID)/\(postID)/likes/\(appDel.userData.uid)", data: uint(NSDate().timeIntervalSince1970))
        
        self.likeButton.removeTarget(nil, action: nil, for: .allEvents)
        self.likeButton.addTarget(self, action: #selector(self.dislikeButton(_:)), for: .touchUpInside)
        self.likeButton.setImage(UIImage(named: "liked"), for: .normal)
        self.numberLikes.text = String(Int(self.numberLikes.text!)! + 1)
    }
    
    @objc func dislikeButton(_ sender : Any) {
         let appDel = UIApplication.shared.delegate as! AppDelegate
        DatabaseBridge.remove(path: "posts/\(userID)/\(postID)/likes/\(appDel.userData.uid)")
        
        self.likeButton.removeTarget(nil, action: nil, for: .allEvents)
        self.likeButton.addTarget(self, action: #selector(self.likeClicked(_:)), for: .touchUpInside)
        self.likeButton.setImage(UIImage(named: "like"), for: .normal)
        self.numberLikes.text = String(Int(self.numberLikes.text!)! - 1)
    }
}
