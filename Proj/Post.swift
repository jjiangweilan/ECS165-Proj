//
//  Post.swift
//  Proj
//
//  Created by jiehong jiang on 2/23/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var profilePic : UIImage?
    var userID : String?
    var userName : String?
    var likes : [(String,String)]? //(username, userid)
    var image : UIImage
    var text : String
    var time : uint
    
    init(userName : String?, profilePic : UIImage?, text : String, image : UIImage, likes : [(String,String)]) {
        self.userName = userName
        self.profilePic = profilePic
        self.image = image
        self.text = text
        self.likes = likes
        self.time = 3;
        self.userID = "123";
    }
}
