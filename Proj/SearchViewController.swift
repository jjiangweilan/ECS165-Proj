//
//  SearchPageControllerViewController.swift
//  Proj
//
//  Created by jiehong jiang on 2/11/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    /*Support type*/
    @IBOutlet weak var seachedUserName: UILabel!
    enum SearchType {
        case USER, CONTENT, PLACE
    }
    
    /*Outlet*/
    @IBOutlet weak var searchBar: UISearchBar!
    
    /*Members*/
    var selectedSearchType : SearchType = SearchType.USER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        switch selectedSearchType {
        case .USER:
            
            DatabaseBridge.queryUserInfo(byEmail: searchBar.text ?? "") { (snapshot) in

                if let userInfo = snapshot.value as? Dictionary<String, Dictionary<String, String>> {
                    
                    self.displaySearchedUserInfo(userInfo: userInfo.values.first!)
                    searchBar.endEditing(true)
                }
                else {
                    self.displaySeachNotFoundAlert()
                }
            }
        default:
            break
        }
    }
    
    func displaySearchedUserInfo(userInfo : Dictionary<String, String>) {
        seachedUserName.text = userInfo["username"]
    }
    
    func displaySeachNotFoundAlert() {
        seachedUserName.text = "Label"
        let alert = UIAlertController(title: "User didn't find", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    /*
     
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
