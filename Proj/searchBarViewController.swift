//
//  searchBarViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 2/10/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class searchBarViewController: UIViewController{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var usersArray = [NSDictionary?]() //Stores all the users from my database
    var filteredUsers = [NSDictionary?]() //only the users that are filtered when we type in the search bar
    
    var databaseRef = Database.database().reference()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var followUsersTableView: UITableView!
    
    //get the information from data base store it as an array
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        UITableViewHeader = searchController.searchBar
        
//        databaseRef.child("name").queryOrdered(byChild: "username").observe(.childAdded, with: {(snapshot) in })
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController){
        
        //update the search result
    }
    
    func
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
