//
//  ProfilePostViewController.swift
//  Proj
//
//  Created by Zexu Li on 3/11/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class ProfilePostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var posts : [Post]? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let p = posts {
            return p.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        if let p = posts {
            cell.postpic.image = p[indexPath.row].image
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionView = self.view.viewWithTag(5) as! UICollectionView
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let collectionView = self.view.viewWithTag(5) as! UICollectionView
        
        collectionView.reloadData()
        
    }
    
}
