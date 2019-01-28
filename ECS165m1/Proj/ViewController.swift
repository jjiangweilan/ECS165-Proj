//
//  ViewController.swift
//  Proj
//
//  Created by jiehong jiang on 1/10/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let helloWorld = UITextView(frame: CGRect( x: 30,y : 30, width: 100, height: 100))
        helloWorld.text = "Hello World"
        view.addSubview(helloWorld)
    }
}

