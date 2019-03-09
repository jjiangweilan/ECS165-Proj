//
//  PostCell.swift
//  homepage
//
//  Created by Xiaofang Jiang on 3/4/19.
//  Copyright © 2019 Xiaofang Jiang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var post: Post!
    var userPostKey: DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImg.layer.borderWidth = 1
        userImg.layer.masksToBounds = false
        userImg.layer.borderColor = UIColor.black.cgColor
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(post: Post, img: UIImage? = nil, userImg: UIImage? = nil){
        self.post = post
        self.likesLable.text = "\(post.likes)"
        self.username.text = post.username
        
        if img != nil{
            self.postImg.image = img
        }else{
            let ref = Storage.storage().reference(forURL: post.postImg)
            ref.getData(maxSize: 2 * 1024, completion: {(data, error) in
                if error != nil{
                    print("Could not load image")
                }else{
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                        }
                    }
                }
                
                
            })
        }
        
        
        if userImg != nil{
            self.postImg.image = userImg
        }else{
            let ref = Storage.storage().reference(forURL: post.userImg)
            ref.getData(maxSize: 2 * 1024, completion: {(data, error) in
                if error != nil{
                    print("Could not load image")
                }else{
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                        }
                    }
                }
                
                
            })
        }
        
    }
    
}
