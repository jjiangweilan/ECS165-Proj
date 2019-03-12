//
//  PostTableViewController.swift
//  Proj
//
//  Created by jiehong jiang on 2/23/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    var postArr : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postArr =  populateTableDataByCurrentUser()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return postArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell Reuse Identifier", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = postArr[indexPath.section].image
        
        let contentView = cell.contentView.viewWithTag(2) as! UILabel
        contentView.text = postArr[indexPath.section].content
        contentView.sizeToFit()
        
        let profilePic = cell.contentView.viewWithTag(3) as! UIImageView
        profilePic.image = postArr[indexPath.section].profilePic
        
        let postUserName = cell.contentView.viewWithTag(4) as! UILabel
        postUserName.text = postArr[indexPath.section].userName
        
        return cell
    }
    
    func populateTableDataByCurrentUser() -> [Post] {
        var postArr = [Post]()
        
        return postArr
    }
    
    func populateTableData() -> [Post] {
        var postArr = [Post]()
        
        return postArr
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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

}
