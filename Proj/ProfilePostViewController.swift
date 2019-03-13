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
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let collectionView = self.view.viewWithTag(5) as! UICollectionView
        
        collectionView.reloadData()
        
    }
    
}
