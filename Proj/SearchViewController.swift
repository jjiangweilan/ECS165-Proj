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
        return currentUserArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = currentUserArray[indexPath.row].uid
        
        let mainProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainProfileViewController") as! MainProfileViewController
        
        mainProfileViewController.mode = .ObserveMode
        mainProfileViewController.userData = UserData()
        mainProfileViewController.dataBaseHandles = UserData.populate(userData: mainProfileViewController.userData, userID: userID)
        
        self.present(mainProfileViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /*
     func tableview(_ tableview: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     return searchBar
     }
     */
    
    // implement search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!;
        currentUserArray.removeAll()
        DatabaseBridge.searchUser(userName: searchText) { (snapshot) in
            let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
            for user in userInfo {
                DatabaseBridge.getProfilePic(userID: user.key, callback: { (data, error) in
                    
                    let userDict = user.value as! [String : Any]
                    self.currentUserArray.append(User(uid : user.key, name: userDict["username"] as! String, introduction: "Placeholder for desscription", image: UIImage(data: data ?? Data()) ?? nil))
                    
                    self.table.reloadData()
                })
            }
        }
    }
    
    
    // search by user name and tag
    // need to use firebase API
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
