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
    var profilePic : UIImage
    var userName : String
    var likes : Int
    var image : UIImage
    var text : String
    
    init(userName : String, profilePic : UIImage, text : String, image : UIImage, likes : Int) {
        self.userName = userName
        self.profilePic = profilePic
        self.image = image
        self.text = text
        self.likes = likes
    }
}
