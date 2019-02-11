//
//  profileViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 1/27/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
// 

import UIKit

class ProfileViewController: UIViewController {
    
    var userInterest = [String]()

    @IBAction func fastFood(_ sender: Any) {
        userInterest.append("Fastfood")
    }
    
    @IBAction func dessert(_ sender: Any) {
        userInterest.append("Dessert")
    }
    
    @IBAction func breakFast(_ sender: Any) {
        userInterest.append("Breakfast")
    }
    
    
    @IBAction func chineseFood(_ sender: Any) {
        userInterest.append("Chinesefood")
    }
    
    
    @IBAction func japaneseFood(_ sender: Any) {
        userInterest.append("Japanesefood")
    }
    
    
    @IBAction func koreanFood(_ sender: Any) {
        userInterest.append("Koreanfood")
    }
    
    
    @IBAction func thaiFood(_ sender: Any) {
        userInterest.append("Thaifood")
    }
    
    @IBAction func indianFood(_ sender: Any) {
        userInterest.append("Indianfood")
    }
    
    
    @IBAction func italianFood(_ sender: Any) {
        userInterest.append("Italianfood")
    }
    
    
    @IBAction func pub(_ sender: Any) {
        userInterest.append("Pub")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
