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
            "phone" : "123456"
        ]
        ref.child("users/\(user.user.uid)").setValue(userDataTemplate)
    }
    
    static func getUserInfo(snapshotFunc : @escaping (DataSnapshot) -> Void) {

        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            snapshotFunc(snapshot)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func resetPassword(withEmail : String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: withEmail, completion: completion);
    }
    
    static func searchUser(userName : String, callback : @escaping (DataSnapshot) -> Void) {
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: userName).observeSingleEvent(of: DataEventType.value, with: callback)
        /*{ (snapshot) in
         let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
         }*/
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
    
    static func uploadImage(postID : String, imageData : Data) {
        let imageRef = storageRef.child("images/\(postID)")
    
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
//            riversRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
//            }
        }
        
    }
}
