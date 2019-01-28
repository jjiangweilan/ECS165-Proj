//
//  profileViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 1/27/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {

    
    @IBOutlet weak var fastFood: UIButton!
    @IBOutlet weak var resturant: UIButton!
    @IBOutlet weak var homemade: UIButton!
    @IBOutlet weak var asianFood: UIButton!
    @IBOutlet weak var americaFood: UIButton!
    @IBOutlet weak var europeFood: UIButton!
    @IBOutlet weak var africaFood: UIButton!
    @IBOutlet weak var dessert: UIButton!
    @IBOutlet weak var brunch: UIButton!
    
    var userChoices: Array<String>
    
    @IBAction func fastFoodTouched(_ sender: UIButton) {
        print("Fast Food being choosed")
        userChoices.append("FastFood")
    }
    
    
    @IBAction func resturantTouched(_ sender:UIButton) {
        print("Resturant being choosed")
        userChoices.append("Resturant")
    }
    

    @IBAction func homemadeTouched(_ sender: UIButton) {
        print("Homemade being choosed")
        userChoices.append("Homemade")
    }
    
    
    @IBAction func asianFoodTouched(_ sender:UIButton) {
        print("Asian Food being choose")
        userChoices.append("Asian Food")
    }
    
    
    @IBAction func americaFoodTouched(_ sender: UIButton) {
        print("America Food being choose")
        userChoices.append("America Food")
    }
    
    
    @IBAction func europeFoodTouched(_ sender: UIButton) {
        print("Europe Food being choosed")
        userChoices.append("Europe Food")
    }
    
    
    @IBAction func africaFoodTouched(_ sender: UIButton) {
        print("Africa Food being choosed")
        userChoices.append("Africa Food")
    }
    
    
    @IBAction func dessertTouched(_ sender: UIButton) {
        print("Dessert being choosed")
        userChoices.append("Dessert")
    }
    
    
    @IBAction func brunchTouched(_ sender: UIButton) {
        print("Brunch being choosed")
        userChoices.append("Brunch")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
