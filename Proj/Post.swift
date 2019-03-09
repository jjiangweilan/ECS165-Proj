//
//  Posts.swift
//  homepage
//
//  Created by Xiaofang Jiang on 3/3/19.
//  Copyright © 2019 Xiaofang Jiang. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _username: String!
    private var _userImg: String!
    private var _postImg: String!
    private var _likes: Int!
    private var _postkey: String!
    private var _postRef: DatabaseReference!
    
    var username: String{
        return _username
    }
    
    var userImg: String{
        return _userImg
    }
    
    var postImg: String{
        get {
            return _postImg
        }set{
            _postImg = newValue
        }
    }
    var likes: Int{
        return _likes
    }
    var postkey: String{
        return _postkey
    }
    
    init(imgUrl: String, likes: Int, username:String, userImg:String){
        _likes = likes
        _postImg = imgUrl
        _username = username
        _userImg = userImg
    }
    
    init(postkey: String, postData:Dictionary<String, AnyObject>){
        _postkey = postkey
        
        if let username = postData["username"] as? String{
            _username = username
        }
        if let userImg = postData["userImg"]as? String{
            _userImg = userImg
        }
        if let postImage = postData["imageUrl"]as? String{
            _postImg = postImage
        }
        if let likes = postData["likes"] as? Int{
            _likes = likes
        }
        
        _postRef = Database.database().reference().child("posts")
    }
    
}
