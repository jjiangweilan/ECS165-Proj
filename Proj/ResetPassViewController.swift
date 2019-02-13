//
//  ResetPassViewController.swift
//  Proj
//
//  Created by wwer on 2/11/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController {

    @IBOutlet weak var setPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func proceedButton(_ sender: Any) {
        print("proceed button tapped.")
        
        if (setPassTextField.text?.isEmpty)! ||
        (confirmPassTextField.text?.isEmpty)!
        {
        displayAlert(userMessage: "All fields are required to fill in")
    }
        
        if ((setPassTextField.text?.elementsEqual(confirmPassTextField.text!))! != true)
        {
            // Display alert messege and return
            displayAlert(userMessage: "Please make sure that passwords match")
            return
        }
    }
    
    
    func displayAlert(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action:UIAlertAction!) in
                    print("Ok button tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController,animated: true, completion: nil)
                
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
