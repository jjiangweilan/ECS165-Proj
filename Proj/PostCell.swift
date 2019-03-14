//
//  PostCell.swift
//  Proj
//
//  Created by jiehong jiang on 3/13/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var PostPic: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var likeUsers: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
