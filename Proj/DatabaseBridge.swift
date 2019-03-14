//
//  File.swift
//  Proj
//
//  Created by jiehong jiang on 1/24/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UserNotifications

class DatabaseBridge {
    static var ref : DatabaseReference!
    static var storageRef : StorageReference!
    static func initRef() {
        if let _ = ref {

        }
        else {
            ref = Database.database().reference()
            storageRef = Storage.storage().reference()
        }
    }
    
    //completion function can't be warpped since it happends in the future
    static func createUser(withEmail : String, password : String, completion : AuthDataResultCallback?) -> Bool {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: completion)
        return true;
    }
    
    //completion function can't be warpped since it happends in the future
    static func signIn(withEmail : String, password : String, completion : AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: withEmail, password: password, completion : completion)
    }
    
    static func updateUserInfo(key : String, value : String) {
        ref.child("users/\(Auth.auth().currentUser!.uid)/\(key)").setValue(value)
    }
    
    static func createUserData(user : AuthDataResult, name : String, email : String) {
        let userDataTemplate = [
            "username" : name,
            "email" : email,
            "profile picture" : "nil",
            "gender" : "secrete",
            "phone" : "123456",
            "introduction" : "Hello, I'm\(name)"
        ]
        ref.child("users/\(user.user.uid)").setValue(userDataTemplate)
    }
    
    static func getUserInfo(uid : String, snapshotFunc : @escaping (DataSnapshot) -> Void) -> DatabaseHandle {
        return ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            snapshotFunc(snapshot)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func resetPassword(withEmail : String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: withEmail, completion: completion);
    }
    
    static func searchUser(userName : String, callback : @escaping (DataSnapshot) -> Void) {
        ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: userName).queryEnding(atValue: "\(userName)" + "\u{f8ff}").observeSingleEvent(of: DataEventType.value, with: callback)
    }
    
    static func queryUserInfo(byEmail email : String,  callback : @escaping (DataSnapshot) -> Void) {
        ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: DataEventType.value, with: callback)
    }
    
    static func databaseHas(path : String, hasCallback : (() -> Void)?, hasNotCallback : (() -> Void)?) {
        ref.child(path).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if (snapshot.exists()) {
                if let f = hasCallback {
                    f()
                }
            }
            else {
                if let f = hasNotCallback {
                    f()
                } 
            }
        }
    }
    
    static func updateData(path : String, data : Any) {
        ref.child(path).setValue(data)
    }
    
    static func uploadProfilePic(userID : String, imageData : Data) {
        let profileRef = storageRef.child("profilePicture/\(userID)")
        
        profileRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                return
            }
        }
    }
    
    static func getProfilePic(userID : String, callback : @escaping (Data?, Error?) -> Void) {
        let profileRef = storageRef.child("profilePicture/\(userID)")
        
        profileRef.getData(maxSize: 20 * 1024 * 1024, completion: callback)
    }
    
    static func uploadImage(userID : String, timeStampAsPostID : uint, imageData : Data) {
        let imageRef = storageRef.child("images/\(userID)/\(timeStampAsPostID)")
    
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
        }
    }
    
    static func getUserPosts(uid : String, snapshotFunc : @escaping (DataSnapshot) -> Void) -> DatabaseHandle {
        return ref.child("posts/\(uid)").queryOrderedByKey().observe(.value, with: snapshotFunc)
    }
    
    static func getUserPostsImage(uid : String, pid : String, callback : @escaping (Data?, Error?) -> Void) {
        let imageRef = storageRef.child("images/\(uid)/\(pid)")
        
        imageRef.getData(maxSize: 20 * 1024 * 1024, completion: callback)
    }
    
    static func followUser(followingID : String) {
        let time = uint(NSDate().timeIntervalSince1970)
        ref.child("follow/\(Auth.auth().currentUser!.uid)/following/\(followingID)").setValue(time)
        ref.child("follow/\(followingID)/follower/\(Auth.auth().currentUser!.uid)").setValue(time)
    }
    
    static func getFirstFewPosts(uid : String, snapshotFunc : @escaping (DataSnapshot) -> Void) {
        ref.child("posts/\(uid)")
    }
    
    static func singleObservation(path : String, snapshotFunc : @escaping (DataSnapshot) -> Void) {
        ref.child("\(path)").observeSingleEvent(of: .value, with: snapshotFunc)
    }
    
    static func getPostWithTag(tag : String, limit : UInt, snapshotFunc : @escaping (DataSnapshot) -> Void) {
        ref.child("tags/\(tag)").queryOrdered(byChild: "lastPost").queryLimited(toLast: limit).observeSingleEvent(of: .value, with: snapshotFunc)
    }
    
    static func observeFollower(uid : String) -> DatabaseHandle {
        return ref.child("follow/\(uid)/follower").queryOrderedByValue().queryStarting(atValue: uint(NSDate().timeIntervalSince1970)).observe(.childAdded) { (snapshot) in
            
            let content = UNMutableNotificationContent()
            content.body = "A User Has Followed you"
            content.categoryIdentifier = "UserType"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
        //notification
    }
    
    static func getFollowing(uid : String, callback : @escaping (DataSnapshot) -> Void) ->DatabaseHandle {
        return ref.child("follow/\(uid)/following").observe(DataEventType.value, with: callback)
    }
    
    static func getFollower(uid : String, callback : @escaping (DataSnapshot) -> Void) ->DatabaseHandle {
        return ref.child("follow/\(uid)/follower").observe(DataEventType.value, with: callback)
    }
    
    static func unfollow(uid: String) {
        ref.child("follow/\(Auth.auth().currentUser!.uid)/following/\(uid)").removeValue()
        ref.child("follow/\(uid)/follower/\(Auth.auth().currentUser!.uid)").removeValue()
    }
    
    static func stopObserving(handle : DatabaseHandle)  {
        ref.removeObserver(withHandle: handle)
    }
}
