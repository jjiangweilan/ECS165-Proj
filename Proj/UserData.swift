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
    
    var follower = [String]()
    var following = [String]()
    
    static func populate (userData : UserData, userID : String) -> [DatabaseHandle] {
        var handles : [DatabaseHandle]! = nil
        
        let handle1 = DatabaseBridge.getUserInfo(snapshotFunc: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            userData.uid = userID
            userData.gender = value?["gender"] as! String
            userData.email = value?["email"] as! String
            userData.lastPost = value?["lastPost"] as! Int
            userData.realName = value?["name"] as! String
            userData.phone = value?["phone"] as! String
            userData.userName = value?["username"] as! String
        })
        
        DatabaseBridge.getProfilePic(userID: userID, callback: { (data, error) in
            if let imageData = data {
                userData.profilePic = UIImage(data: imageData) ?? UIImage()
            }
        })
        
        let handle2 = DatabaseBridge.getUserPosts(uid : userID, snapshotFunc : { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            value?.forEach({ (key, value) in
                let key = key as! String
                let value = value as! NSDictionary
                for p in userData.posts {
                    if (key == "\(p.time as! uint)") {
                        continue
                    }
                }                
                
                var post = Post()
                post.content = value["content"] as! String
                post.likes = value["like"] as? [String]
                post.userID = userID
                post.time = value["timeStamp"] as! uint
                
                
                DatabaseBridge.getUserPostsImage(uid: userID, pid: key, callback: { (data, nil) in
                    post.image = UIImage(data: data ?? Data())

                    userData.posts.append(post)
                })
            })
        })
        
        let handle3 = DatabaseBridge.getFollower(uid: userID, callback: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let v = value {
                userData.follower = v.allKeys as! [String]
            }
        })
        
        let handle4 = DatabaseBridge.getFollowing(uid: userID, callback: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let v = value {
                userData.following = v.allKeys as! [String]
                let content = UNMutableNotificationContent()
                content.body = "A User Has Followed you"
                content.categoryIdentifier = "UserType"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request)
            }
        })
        
        handles = [handle1, handle2, handle3, handle4]
        
        return handles
    }
}
