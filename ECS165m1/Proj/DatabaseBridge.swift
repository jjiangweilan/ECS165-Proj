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
    static func initRef() {
        if let _ = ref {

        }
        else {
            ref = Database.database().reference()
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
    
    static func updateUserInfo(path : String, value : String) {
        ref.child("users/\(Auth.auth().currentUser!.uid)/\(path)").setValue(value)
    }
    
    static func createUserData(user : AuthDataResult) {
        
    }
}
