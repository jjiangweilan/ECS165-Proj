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
        userArray.append(User(name: "Eva", introduction: "I love cat!", image:"1"))
        userArray.append(User(name: "Jiehong", introduction: "I love dog!", image:"2"))
        userArray.append(User(name: "Zexu", introduction: "I love food!", image:"3"))
        userArray.append(User(name: "Xiaofang", introduction: "I love everything!", image:"4"))
        userArray.append(User(name: "Xiaofang", introduction: "I love everything!", image:"4"))
        currentUserArray = userArray
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = currentUserArray[indexPath.row].name
        cell.IntroductionLabel.text = currentUserArray[indexPath.row].introduction
        cell.imageView?.contentMode =  .scaleAspectFit
        cell.imageView?.image = UIImage(named:currentUserArray[indexPath.row].image)
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
        var searchText = searchBar.text!;
        
        DatabaseBridge.searchUser(userName: searchText) { (snapshot) in
            print(snapshot.value.debugDescription)
        }
        
        table.reloadData()
    }
    
    
    // search by user name and tag
    // need to use firebase API
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        /*
         switch selectedScope {
         // search by user name
         case 0:
         // find users from firebase
         currentUserArray = findUser()
         })
         // search by tag
         case 1:
         // find tag content from firebase
         currentUserArray = findTagContent()
         }
         */
    }
    
    
    class User{
        let name: String
        let introduction: String
        let image: String
        
        init(name: String, introduction: String, image: String) {
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
