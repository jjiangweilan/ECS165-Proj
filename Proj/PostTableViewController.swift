//
//  PostTableViewController.swift
//  Proj
//
//  Created by jiehong jiang on 2/23/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class PostTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postArr : [Post] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        dataUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.reloadDataAfterFetch()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 295
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else {
            return UITableViewCell()
        }
        
        cell.userName.text = postArr[indexPath.row].userName
        
        cell.likeUsers.text = postArr[indexPath.row].likes?.joined(separator: ",")
        cell.likeUsers.isUserInteractionEnabled = false
        cell.PostPic.image = postArr[indexPath.row].image
        cell.textContent.text = postArr[indexPath.row].content
        
        DatabaseBridge.getProfilePic(userID: postArr[indexPath.row].userID) { (data, nil) in
            if let d = data {
                cell.userProfilePic.image = UIImage(data: d)
            }
        }
        cell.textContent.isUserInteractionEnabled = false
        return cell
    }

    func reloadDataAfterFetch() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! ShowPostViewController
        let _ = controller.view
        
        controller.numberLikes.text = "\(postArr[indexPath.row].likes?.count ?? 0)"
        controller.postContent.text = postArr[indexPath.row].content
        controller.postPic.image = postArr[indexPath.row].image
        controller.profilePic.image = postArr[indexPath.row].profilePic
        controller.user.text = postArr[indexPath.row].userName
        controller.postID = postArr[indexPath.row].postID
        controller.userID = postArr[indexPath.row].userID
        
        self.present(controller, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func dataUpdate() {
        postArr.removeAll()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let userData = appDel.userData
        if userData.uid == "" {
            return
        }
        
        DatabaseBridge.singleObservation(path: "follow/\(userData.uid)/following") { (dataSnapshot) in
            if let value = dataSnapshot.value as? NSDictionary {
                
            }
            else {
                return
            }
            let value = dataSnapshot.value as! NSDictionary
            var postCount = 30
            for userID in value.allKeys as! [String] {
                if postCount == 0 {
                    break
                }
                var thisPostCount = 3
                
                DatabaseBridge.singleObservation(path: "posts/\(userID)") { (dataSnapshot) in
                    let postMap = dataSnapshot.value as! NSDictionary
                    
                    for value in postMap {
                        if thisPostCount == 0 {
                            break
                        }
                        let postValue = value.value as! NSDictionary
                        thisPostCount -= 1
                        postCount -= 1
                        
                        let post = Post()
                        DatabaseBridge.singleObservation(path: "users/\(userID)/username", snapshotFunc: { (dataSnapshot) in
                            let post = Post()
                            post.userName = dataSnapshot.value as! String
                            post.userID = userID
                            post.time = postValue["timeStamp"] as! uint
                            post.content = postValue["content"] as? String ?? ""
                            post.tags = postValue["tags"] as? NSArray as? [String]
                            let likes =  postValue["likes"] as? NSDictionary
                            post.likes = likes?.allValues as? [String]
                            post.postID = value.key as! String
                            
                            DatabaseBridge.getUserPostsImage(uid: userID, pid: value.key as! String, callback: { (data, nil) in
                                post.image = UIImage(data: data ?? Data())
                                
                                self.postArr.append(post)
                                self.tableView.reloadData()
                            })
                            
                        })
                    }
                }
            }
        }
    }
}
