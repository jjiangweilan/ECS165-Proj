//
//  File.swift
//  Proj
//
//  Created by jiehong jiang on 1/24/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import Foundation
import Firebase
class DatabaseBridge {
    static func createUser(withEmail : String, password : String) -> Bool {
        Auth.auth().createUser(withEmail: withEmail, password: password){ (authResult, error) in

            guard let user = authResult?.user else { return }
        }
        
        return true;
    }
}
