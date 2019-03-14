//
//  UserData.swift
//  Proj
//
//  Created by jiehong jiang on 3/11/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase

class UserData {
    var userName : String = ""
    var gender : String = ""
    var lastPost : Int = 0
    var realName : String = ""
    var phone : String = ""
    var profilePic : UIImage = UIImage()
    var email : String = ""
    var posts : [Post] = [Post]()
    var uid : String = ""
    var introduction : String = ""
    var follower = [String]()
    var following = [String]()
    
    static func populate (userData : UserData, userID : String, callback : (()->())? = nil) -> [DatabaseHandle] {
        var handles : [DatabaseHandle]! = nil
        
        let handle1 = DatabaseBridge.getUserInfo(uid: userID, snapshotFunc: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            userData.uid = userID
            userData.gender = value?["gender"] as! String
            userData.email = value?["email"] as! String
            userData.realName = value?["name"] as? String ?? ""
            userData.phone = value?["phone"] as? String ?? ""
            userData.userName = value?["username"] as! String
            userData.introduction = value?["introduction"] as! String
            
            if let c = callback {
                c()
            }
        })
        
        DatabaseBridge.getProfilePic(userID: userID, callback: { (data, error) in
            if let imageData = data {
                userData.profilePic = UIImage(data: imageData) ?? UIImage()
            }
            else {
                print(error)
            }
            if let c = callback {
                c()
            }
        })
        
        let handle2 = DatabaseBridge.getUserPosts(uid : userID, snapshotFunc : { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            var newPosts = [Post]()
            value?.forEach({ (key, value) in
                let key = key as! String
                let value = value as! NSDictionary
                
                DatabaseBridge.getProfilePic(userID: userID, callback: { (data, error) in
                    let post = Post()
                    post.content = value["content"] as! String
                    post.likes = value["like"] as? [String]
                    post.userID = userID
                    post.time = value["timeStamp"] as! uint
                    post.tags = value["tags"] as? [String] ?? [String]()
                    post.postID = key
                    post.userName = userData.userName
                    if let imageData = data {
                        post.profilePic = UIImage(data: imageData) ?? UIImage()
                    }
                    else {
                        print(error)
                    }
                    DatabaseBridge.getUserPostsImage(uid: userID, pid: key, callback: { (data, nil) in
                        post.image = UIImage(data: data ?? Data())
                        newPosts.append(post)
                        userData.posts = newPosts
                        if let c = callback {
                            c()
                        }
                    })
                })
            })
        })
        
        let handle3 = DatabaseBridge.getFollower(uid: userID, callback: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let v = value {
                userData.follower = v.allKeys as! [String]
            }
            
            if let c = callback {
                c()
            }
        })
        
        let handle4 = DatabaseBridge.getFollowing(uid: userID, callback: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let v = value {
                userData.following = v.allKeys as! [String]
            }
            
            if let c = callback {
                c()
            }
        })
        handles = [handle1, handle2, handle3, handle4]
        
        return handles
    }
}
