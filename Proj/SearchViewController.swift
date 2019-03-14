//
//  SearchController.swift
//  Proj
//
//  Created by wwer on 2/22/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userArray = [User]()
    var currentUserArray = [User]() // updata table
    
    var currentPostArray = [Post]()
    var postArray = [Post]()
    
    var scope : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
        setSearchBar()
        // to keep search bar always on top
        alterLayout()
        // Do any additional setup after loading the view.
    }
    
    
    // fake save input user info
    private func setUserInfo(){
        
    }
    
    private func setSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in navigation bar
        searchBar.placeholder = "Search User by Name or search by Tag"
    }
    
    // table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scope == 0 {
            return currentUserArray.count
        }
        else {
            return currentPostArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scope == 0 {
            let userID = currentUserArray[indexPath.row].uid
            
            let mainProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainProfileViewController") as! MainProfileViewController
            
            mainProfileViewController.mode = .ObserveMode
            mainProfileViewController.userData = UserData()
            mainProfileViewController.userData.uid = userID
            
            self.present(mainProfileViewController, animated: true, completion: nil)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! ShowPostViewController
            let _ = controller.view
            controller.numberLikes.text = "\(currentPostArray[indexPath.row].likes.count)"
            controller.postContent.text = currentPostArray[indexPath.row].content
            controller.postPic.image = currentPostArray[indexPath.row].image
            controller.profilePic.image = currentPostArray[indexPath.row].profilePic
            controller.user.text = currentPostArray[indexPath.row].userName
            
            self.present(controller, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.scope == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.nameLabel.text = currentUserArray[indexPath.row].name
            cell.IntroductionLabel.text = currentUserArray[indexPath.row].introduction
            cell.imageView?.contentMode =  .scaleAspectFit
            cell.imageView?.image = currentUserArray[indexPath.row].image
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0);
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else {
                return UITableViewCell()
            }
            
            cell.userName.text = currentPostArray[indexPath.row].userName

            cell.likeUsers.text = currentPostArray[indexPath.row].likes?.joined(separator: ",")
            cell.likeUsers.isUserInteractionEnabled = false
            cell.PostPic.image = currentPostArray[indexPath.row].image
            cell.textContent.text = currentPostArray[indexPath.row].content
            
            DatabaseBridge.getProfilePic(userID: currentPostArray[indexPath.row].userID) { (data, nil) in
                if let d = data {
                    cell.userProfilePic.image = UIImage(data: d)
                }
            }
            cell.textContent.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if scope == 0{
            return 50
        }
        else {
            return 295
        }
    }
    
    /*
     func tableview(_ tableview: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     return searchBar
     }
     */
    
    // implement search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if scope == 0 {
            let searchText = searchBar.text!;
            currentUserArray.removeAll()
            let appDel = UIApplication.shared.delegate as! AppDelegate
            DatabaseBridge.searchUser(userName: searchText) { (snapshot) in
                let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
                for user in userInfo {
                    let userDict = user.value as! [String : Any]
                    if user.key == appDel.userData.uid {
                        continue
                    }
                    DatabaseBridge.getProfilePic(userID: user.key, callback: { (data, error) in
                        self.currentUserArray.append(User(uid : user.key, name: userDict["username"] as! String, introduction: userDict["introduction"] as! String, image: UIImage(data: data ?? Data()) ?? nil))
                        
                        self.table.reloadData()
                    })
                    searchBar.endEditing(true)
                }
            }
        }
        else {
            let searchText = searchBar.text!;
            currentPostArray.removeAll()
            DatabaseBridge.getPostWithTag(tag: searchText, limit: 20) { (dataSnapshot) in
                let value = dataSnapshot.value as! NSDictionary

                var postCount = 20
                for userID in value.allKeys as! [String] {
                    if postCount == 0 {
                        break
                    }
                    var thisPostCount = 3
                    for postData in value[userID] as! [String : UInt] {
                        let postID = postData.key
                        if postID == "lastPost" {
                            continue
                        }
                        if thisPostCount == 0 {
                            break
                        }
                        thisPostCount -= 1
                        postCount -= 1
                        DatabaseBridge.singleObservation(path: "posts/\(userID)/\(postID)", snapshotFunc: { (dataSnapshot) in
                            let postValue = dataSnapshot.value as! NSDictionary
                            
                            DatabaseBridge.singleObservation(path: "users/\(userID)/username", snapshotFunc: { (dataSnapshot) in
                                let post = Post()
                                post.userName = dataSnapshot.value as! String
                                post.userID = userID
                                post.time = postValue["timeStamp"] as! uint
                                post.content = postValue["content"] as? String ?? ""
                                post.tags = postValue["tags"] as! NSArray as? [String]
    
                                DatabaseBridge.getUserPostsImage(uid: userID, pid: postID, callback: { (data, nil) in
                                    post.image = UIImage(data: data ?? Data())
                                })
                                
                                post.likes = postValue["likes"] as! NSArray as? [String]
                                
                                self.currentPostArray.append(post)
                                self.table.reloadData()
                            })
                            
                        })
                    }
                }
            }
        }
    }
    
    
    // search by user name and tag
    // need to use firebase API
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = selectedScope
        self.table.reloadData()
    }
    
    class User{
        let uid : String
        let name : String
        let introduction : String
        let image : UIImage?
        
        init(uid : String, name: String, introduction: String, image: UIImage?) {
            self.uid = uid;
            self.name = name
            self.introduction = introduction
            self.image = image
        }
    }
    
}
