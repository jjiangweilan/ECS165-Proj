//
//  FollowUsersTableTableViewController.swift
//  
//
//  Created by Xiaofang Jiang on 2/10/19.
//

import UIKit
import FirebaseDatabase

class FollowUsersTableTableViewController: UITableViewController, UISearchResultsUpdating {
    
 

    @IBOutlet var followUsersTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    
    var databaseRef = Database.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView =  searchController.searchBar
        
    databaseRef.child("user_profiles").queryOrdered(byChild:"username" ).observe(.childAdded, with: {(snapshot) in
            //self.usersArray.append(snapshot.value as? NSDictionary?)/ TO_DO
            
            //insert the rows
            
            //self.followUsersTableView.insertRows(at: [IndexPath(row:self,usersArray.count-1, section:0)], with: UITableView.RowAnimation.automatic) // TO_DO
        })
        
        {(error) in
            print(error.localizedDescription)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        return self.usersArray.count
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let user:NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        }
        else{
            user = self.usersArray[indexPath.row]
        }
        
        cell.textLabel?.text = user?["name"]as? String
        cell.detailTextLabel?.text = user?["handle"]as? String

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateSearchResults(for searchController: UISearchController) {
        filtereContent(searchTex: self.searchController.searchBar.text!)
    }
    
    func filtereContent(searchTex: String){
        self.filteredUsers = self.usersArray.filter{user in
            
            let username = user!["name"] as? String
            return(username?.lowercased().contains(searchTex.lowercased()))!
        }
        tableView.reloadData()
    }
}
