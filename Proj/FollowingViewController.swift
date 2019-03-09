//
//  followingViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 2/12/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var searchedName: UILabel!
    @IBAction func followingStarts(_ sender: Any) {
        if followButton.currentTitle == "Follow"{
            followButton.setTitle("Following", for: .normal)
            followButton.tintColor = UIColor.blue
        }
        else{
            followButton.setTitle("Follow",for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
