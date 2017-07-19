//
//  ViewController.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Khordad/07 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backGround: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.image = #imageLiteral(resourceName: "enter")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

