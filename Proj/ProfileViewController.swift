//
//  profileViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 1/27/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
// 

import UIKit

class ProfileViewController: UIViewController {

    
    @IBAction func fastFoodTapped(_ sender: UIButton) {
        print("FastFood choosed")
    }
    
    
    @IBAction func dessertTapped(_ sender: UIButton) {
        print("Dessert choosed")
    }
    
    @IBAction func breakfastTapped(_ sender: UIButton) {
        print("Breakfast choosed")
    }
    
    @IBAction func chineseFoodTapped(_ sender: UIButton) {
        print("ChineseFood choosed")
    }
    
    @IBAction func japaneseFoodTapped(_ sender: Any) {
        print("JapaneseFood choosed")
    }
    
    @IBAction func koreanFoodTapped(_ sender: UIButton) {
        print("KoreanFood choosed")
    }
    
    @IBAction func tahiFoodTapped(_ sender: UIButton) {
        print("ThaiFood choosed")
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
